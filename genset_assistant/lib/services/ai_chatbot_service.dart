import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pdf_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AIChatbotService {
  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String _apiKey = 'sk-fc973493b4a7487681370da8ba7900d5';
  static const String _model = 'deepseek-chat-lite';
  
  final List<ChatMessage> _conversationHistory = [];
  String? _knowledgeBase;

  AIChatbotService() {
    _loadKnowledgeBase();
  }

  Future<void> _loadKnowledgeBase() async {
    try {
      // Load PDF content using the PDF service
      final Map<String, String> pdfContents = await PDFService.getAllPDFContents();
      final List<String> contentList = pdfContents.values.toList();
      
      _knowledgeBase = contentList.join('\n\n');
      debugPrint('Knowledge base loaded successfully with ${pdfContents.length} documents');
    } catch (e) {
      debugPrint('Error loading knowledge base: $e');
      _knowledgeBase = '';
    }
  }

  List<ChatMessage> getConversationHistory() {
    return List.from(_conversationHistory);
  }

  void clearConversation() {
    _conversationHistory.clear();
  }

  Future<String> sendMessage(String userMessage) async {
    try {
      // Add user message to conversation history
      final userChatMessage = ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      );
      _conversationHistory.add(userChatMessage);

      // Prepare messages for API
      final List<Map<String, String>> messages = [
        {
          'role': 'system',
          'content': '''You are a helpful AI assistant for MGM Generator business. You have access to comprehensive knowledge about MGM generators including specifications, maintenance, troubleshooting, and installation guidelines. 

Your knowledge base includes information about:
- Various generator models (10kW to 1000KVA)
- Power banks and battery systems
- Fuel tanks and accessories
- Technical specifications and drawings
- Maintenance procedures
- Installation guidelines
- Troubleshooting information

Please provide accurate, helpful, and professional responses based on this knowledge. If you don't have specific information about a query, be honest and suggest contacting customer support.

Knowledge Base:
$_knowledgeBase'''
        },
      ];

      // Add conversation history (last 10 messages to avoid token limits)
      final recentHistory = _conversationHistory.length > 10 
          ? _conversationHistory.sublist(_conversationHistory.length - 10)
          : _conversationHistory;

      for (final msg in recentHistory) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        });
      }

      // Make API request with optimized parameters for faster response
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': 500, // Reduced for faster response
          'temperature': 0.7,
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 15)); // Added timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantMessage = data['choices'][0]['message']['content'] as String;
        
        // Add assistant response to conversation history
        final assistantChatMessage = ChatMessage(
          text: assistantMessage,
          isUser: false,
          timestamp: DateTime.now(),
        );
        _conversationHistory.add(assistantChatMessage);

        return assistantMessage;
      } else {
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        return 'Sorry, I encountered an error. Please try again later.';
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      return 'Sorry, I\'m having trouble connecting. Please check your internet connection and try again.';
    }
  }

  Future<bool> isOnline() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.deepseek.com/v1/models'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
