import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  static const String _baseUrl = 'https://genset.com.my/wp-json/wp/v2';
  static const int _perPage = 6;

  static Future<List<NewsArticle>> fetchArticles({
    int page = 1,
    int perPage = _perPage,
    String? search,
    List<int>? categories,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        '_embed': 'author,wp:featuredmedia', // Embed author and featured media information
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (categories != null && categories.isNotEmpty) {
        queryParams['categories'] = categories.join(',');
      }

      // Build URL with query parameters
      Uri uri = Uri.parse('$_baseUrl/posts');
      uri = uri.replace(queryParameters: queryParams);

      print('Fetching articles from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'GensetAssistant/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => NewsArticle.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: Invalid parameters');
      } else if (response.statusCode == 404) {
        throw Exception('Not found: No articles available');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: Please try again later');
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<NewsArticle?> fetchArticleById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/$id?_embed=author'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'GensetAssistant/1.0',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return NewsArticle.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load article: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load article: $e');
    }
  }

  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/categories'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'GensetAssistant/1.0',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((cat) => cat['name'] as String).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Test method to check if API is accessible
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts?per_page=1'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'GensetAssistant/1.0',
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Request timeout'),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}
