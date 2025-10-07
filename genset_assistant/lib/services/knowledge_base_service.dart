import 'package:flutter/material.dart';

class KnowledgeItem {
  final String id;
  final String category;
  final String title;
  final String content;
  final List<String> keywords;
  final String? model;
  final String? kvaRating;
  final String? fuelType;

  KnowledgeItem({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.keywords,
    this.model,
    this.kvaRating,
    this.fuelType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'keywords': keywords,
      'model': model,
      'kvaRating': kvaRating,
      'fuelType': fuelType,
    };
  }

  factory KnowledgeItem.fromJson(Map<String, dynamic> json) {
    return KnowledgeItem(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      content: json['content'],
      keywords: List<String>.from(json['keywords']),
      model: json['model'],
      kvaRating: json['kvaRating'],
      fuelType: json['fuelType'],
    );
  }
}

class KnowledgeBaseService {
  static final KnowledgeBaseService _instance = KnowledgeBaseService._internal();
  factory KnowledgeBaseService() => _instance;
  KnowledgeBaseService._internal();

  List<KnowledgeItem> _knowledgeBase = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await _loadStructuredKnowledgeBase();
      _isInitialized = true;
      debugPrint('Knowledge base initialized with ${_knowledgeBase.length} items');
    } catch (e) {
      debugPrint('Error initializing knowledge base: $e');
      // Fallback to basic knowledge if structured loading fails
      _loadFallbackKnowledge();
      _isInitialized = true;
    }
  }

  Future<void> _loadStructuredKnowledgeBase() async {
    // Create structured knowledge base from PDF filenames and common generator information
    _knowledgeBase = [
      // Generator Models
      KnowledgeItem(
        id: 'genset_10kw_power_bank',
        category: 'Generator Models',
        title: '10kW MGM Power Bank',
        content: 'The 10kW MGM Power Bank is a compact power solution suitable for small to medium applications. It provides reliable backup power with advanced battery technology.',
        keywords: ['10kw', 'power bank', 'battery', 'backup', 'compact'],
        model: '10kW Power Bank',
        kvaRating: '10 KVA',
        fuelType: 'Battery',
      ),
      KnowledgeItem(
        id: 'genset_15kva',
        category: 'Generator Models',
        title: '15KVA MGM Generator',
        content: 'The 15KVA MGM Generator is designed for commercial and industrial applications. It offers reliable power generation with fuel efficiency and low emissions.',
        keywords: ['15kva', 'generator', 'commercial', 'industrial', 'diesel'],
        model: '15KVA',
        kvaRating: '15 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_30kva_compact',
        category: 'Generator Models',
        title: '30KVA MGM Compact Generator',
        content: 'The 30KVA MGM Compact Generator is a space-efficient power solution ideal for locations with limited space. It maintains high performance while reducing footprint.',
        keywords: ['30kva', 'compact', 'space-saving', 'efficient', 'diesel'],
        model: '30KVA Compact',
        kvaRating: '30 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_30kva_isuzu',
        category: 'Generator Models',
        title: '30KVA ISUZU Generator',
        content: 'The 30KVA ISUZU Generator features reliable ISUZU engine technology, known for durability and fuel efficiency. Suitable for continuous operation in demanding environments.',
        keywords: ['30kva', 'isuzu', 'engine', 'durable', 'continuous'],
        model: '30KVA ISUZU',
        kvaRating: '30 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_60kva',
        category: 'Generator Models',
        title: '60KVA MGM Generator',
        content: 'The 60KVA MGM Generator provides substantial power for medium to large industrial applications. Features advanced control systems and noise reduction technology.',
        keywords: ['60kva', 'industrial', 'advanced control', 'noise reduction'],
        model: '60KVA',
        kvaRating: '60 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_100kva',
        category: 'Generator Models',
        title: '100KVA MGM Generator',
        content: 'The 100KVA MGM Generator is a high-capacity power solution suitable for large industrial facilities, hospitals, and data centers. Offers redundant power capabilities.',
        keywords: ['100kva', 'high-capacity', 'industrial', 'hospital', 'data center'],
        model: '100KVA',
        kvaRating: '100 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_160kva',
        category: 'Generator Models',
        title: '160KVA MGM Generator',
        content: 'The 160KVA MGM Generator delivers reliable power for large-scale operations. Features advanced monitoring systems and automatic load transfer capabilities.',
        keywords: ['160kva', 'large-scale', 'monitoring', 'automatic transfer'],
        model: '160KVA',
        kvaRating: '160 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_250kva',
        category: 'Generator Models',
        title: '250KVA MGM Generator',
        content: 'The 250KVA MGM Generator is designed for heavy industrial applications. Provides continuous power with high efficiency and low maintenance requirements.',
        keywords: ['250kva', 'heavy industrial', 'continuous', 'efficient', 'low maintenance'],
        model: '250KVA',
        kvaRating: '250 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_350kva',
        category: 'Generator Models',
        title: '350KVA MGM Generator',
        content: 'The 350KVA MGM Generator offers exceptional power output for large facilities. Features paralleling capabilities for scalable power solutions.',
        keywords: ['350kva', 'large facilities', 'paralleling', 'scalable'],
        model: '350KVA',
        kvaRating: '350 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_500kva',
        category: 'Generator Models',
        title: '500KVA MGM Generator',
        content: 'The 500KVA MGM Generator is a powerhouse for critical infrastructure. Provides backup power for essential services with high reliability.',
        keywords: ['500kva', 'critical infrastructure', 'backup power', 'reliable'],
        model: '500KVA',
        kvaRating: '500 KVA',
        fuelType: 'Diesel',
      ),
      KnowledgeItem(
        id: 'genset_1000kva',
        category: 'Generator Models',
        title: '1000KVA MGM Cummins QST',
        content: 'The 1000KVA MGM Cummins QST Generator features Cummins QST engine technology for maximum efficiency and reliability. Suitable for power plants and large industrial complexes.',
        keywords: ['1000kva', 'cummins', 'qst', 'power plant', 'industrial complex'],
        model: '1000KVA Cummins QST',
        kvaRating: '1000 KVA',
        fuelType: 'Diesel',
      ),

      // Maintenance Information
      KnowledgeItem(
        id: 'maintenance_general',
        category: 'Maintenance',
        title: 'General Generator Maintenance',
        content: 'Regular maintenance includes: 1) Check oil levels daily, 2) Replace oil every 250-500 hours, 3) Clean air filters monthly, 4) Check fuel system weekly, 5) Test battery monthly, 6) Inspect belts and hoses quarterly.',
        keywords: ['maintenance', 'oil', 'filters', 'fuel system', 'battery', 'belts', 'hoses'],
      ),
      KnowledgeItem(
        id: 'maintenance_oil',
        category: 'Maintenance',
        title: 'Oil Change Guidelines',
        content: 'Oil should be changed every 250-500 hours of operation or every 6 months, whichever comes first. Use recommended API CF-4 or higher grade oil. Check oil level daily before operation.',
        keywords: ['oil change', '250 hours', '500 hours', 'API CF-4', 'oil level'],
      ),
      KnowledgeItem(
        id: 'maintenance_filters',
        category: 'Maintenance',
        title: 'Filter Maintenance',
        content: 'Air filters should be cleaned monthly and replaced every 1000 hours. Fuel filters should be replaced every 500 hours. Oil filters should be replaced with every oil change.',
        keywords: ['air filter', 'fuel filter', 'oil filter', 'cleaning', 'replacement'],
      ),

      // Troubleshooting
      KnowledgeItem(
        id: 'troubleshooting_start',
        category: 'Troubleshooting',
        title: 'Generator Won\'t Start',
        content: 'Common causes: 1) Empty fuel tank, 2) Dead battery, 3) Faulty spark plugs, 4) Clogged fuel filter, 5) Low oil pressure. Solutions: Check fuel level, charge/replace battery, inspect spark plugs, replace fuel filter, check oil level.',
        keywords: ['wont start', 'no start', 'fuel', 'battery', 'spark plugs', 'fuel filter'],
      ),
      KnowledgeItem(
        id: 'troubleshooting_overheating',
        category: 'Troubleshooting',
        title: 'Generator Overheating',
        content: 'Causes: 1) Low coolant level, 2) Blocked radiator, 3) Faulty thermostat, 4) Worn water pump. Solutions: Check coolant, clean radiator, replace thermostat, inspect water pump.',
        keywords: ['overheating', 'coolant', 'radiator', 'thermostat', 'water pump'],
      ),
      KnowledgeItem(
        id: 'troubleshooting_power',
        category: 'Troubleshooting',
        title: 'Low Power Output',
        content: 'Causes: 1) Overloaded, 2) Clogged air filter, 3) Bad fuel, 4) Faulty voltage regulator. Solutions: Reduce load, clean air filter, drain and replace fuel, check voltage regulator.',
        keywords: ['low power', 'overload', 'air filter', 'fuel quality', 'voltage regulator'],
      ),

      // Installation
      KnowledgeItem(
        id: 'installation_general',
        category: 'Installation',
        title: 'General Installation Guidelines',
        content: 'Installation requirements: 1) Level concrete foundation, 2) Proper ventilation, 3) Weather protection, 4) Access for maintenance, 5) Proper grounding, 6) Fuel storage capacity for 8-12 hours runtime.',
        keywords: ['installation', 'foundation', 'ventilation', 'grounding', 'fuel storage'],
      ),
      KnowledgeItem(
        id: 'installation_cable',
        category: 'Installation',
        title: 'Cable Installation',
        content: 'Cable sizing depends on KVA rating and distance. For 30KVA: Use 25mm² copper cable up to 50m. For 100KVA: Use 70mm² copper cable up to 50m. Always consult local electrical codes.',
        keywords: ['cable', 'wiring', 'cable sizing', 'electrical code', 'installation'],
      ),
      KnowledgeItem(
        id: 'installation_fuel_tank',
        category: 'Installation',
        title: 'Fuel Tank Installation',
        content: 'Fuel tank should be located at least 3m from generator. Use proper piping with shut-off valves. Ensure proper ventilation and fire safety measures. Capacity should support 8-12 hours operation.',
        keywords: ['fuel tank', 'fuel piping', 'safety', 'capacity', 'installation'],
      ),

      // Technical Specifications
      KnowledgeItem(
        id: 'specs_general',
        category: 'Technical Specifications',
        title: 'General Specifications',
        content: 'MGM generators feature: 50Hz frequency, 400V/230V output, 3-phase power, IP23 protection class, ambient temperature up to 50°C, altitude up to 1000m above sea level.',
        keywords: ['specifications', '50hz', '400v', '230v', '3-phase', 'IP23', 'temperature', 'altitude'],
      ),
      KnowledgeItem(
        id: 'specs_control_panel',
        category: 'Technical Specifications',
        title: 'Control Panel Features',
        content: 'Standard control panel includes: Automatic voltage regulator, circuit breakers, hour meter, temperature gauges, fuel level indicator, emergency stop button, battery charger.',
        keywords: ['control panel', 'AVR', 'circuit breaker', 'hour meter', 'gauges', 'emergency stop'],
      ),

      // Accessories
      KnowledgeItem(
        id: 'accessories_fuel_tank_30kva',
        category: 'Accessories',
        title: 'Fuel Tank for 30KVA',
        content: 'Optional fuel tank for 30KVA generators with 500-liter capacity. Features level gauge, drain valve, and lockable cap. Provides approximately 48 hours of continuous operation at 75% load.',
        keywords: ['fuel tank', '30kva', '500 liter', 'accessory', 'extended runtime'],
        model: '30KVA',
        kvaRating: '30 KVA',
      ),
      KnowledgeItem(
        id: 'accessories_oversight_module',
        category: 'Accessories',
        title: 'Oversight Module',
        content: 'Advanced monitoring module for remote generator management. Features real-time monitoring, automatic alerts, performance tracking, and mobile app integration.',
        keywords: ['oversight', 'monitoring', 'remote', 'mobile app', 'tracking'],
      ),
    ];
  }

  void _loadFallbackKnowledge() {
    _knowledgeBase = [
      KnowledgeItem(
        id: 'fallback_info',
        category: 'General',
        title: 'MGM Generator Information',
        content: 'MGM generators provide reliable power solutions from 10KVA to 1000KVA. Features include diesel engines, automatic voltage regulation, and comprehensive warranty support.',
        keywords: ['MGM', 'generator', 'power', 'diesel', 'warranty'],
      ),
    ];
  }

  List<KnowledgeItem> searchKnowledgeBase(String query) {
    if (!_isInitialized) {
      debugPrint('Knowledge base not initialized');
      return [];
    }

    final lowerQuery = query.toLowerCase();
    final queryWords = lowerQuery.split(' ').where((word) => word.length > 2).toList();
    
    List<KnowledgeItem> results = [];

    for (final item in _knowledgeBase) {
      int score = 0;

      // Check for exact matches in title
      if (item.title.toLowerCase().contains(lowerQuery)) {
        score += 10;
      }

      // Check for exact matches in content
      if (item.content.toLowerCase().contains(lowerQuery)) {
        score += 5;
      }

      // Check for keyword matches
      for (final keyword in item.keywords) {
        if (keyword.toLowerCase().contains(lowerQuery)) {
          score += 8;
        }
      }

      // Check for partial matches in keywords
      for (final keyword in item.keywords) {
        for (final queryWord in queryWords) {
          if (keyword.toLowerCase().contains(queryWord)) {
            score += 3;
          }
        }
      }

      // Check for KVA rating matches
      if (item.kvaRating != null && item.kvaRating!.toLowerCase().contains(lowerQuery)) {
        score += 7;
      }

      // Check for model matches
      if (item.model != null && item.model!.toLowerCase().contains(lowerQuery)) {
        score += 7;
      }

      // Check for category matches
      if (item.category.toLowerCase().contains(lowerQuery)) {
        score += 4;
      }

      if (score > 0) {
        results.add(item);
      }
    }

    // Sort by relevance score (descending)
    results.sort((a, b) {
      final scoreA = _calculateRelevanceScore(a, query);
      final scoreB = _calculateRelevanceScore(b, query);
      return scoreB.compareTo(scoreA);
    });

    // Return top 5 most relevant results
    return results.take(5).toList();
  }

  int _calculateRelevanceScore(KnowledgeItem item, String query) {
    final lowerQuery = query.toLowerCase();
    int score = 0;

    if (item.title.toLowerCase().contains(lowerQuery)) score += 10;
    if (item.content.toLowerCase().contains(lowerQuery)) score += 5;
    
    for (final keyword in item.keywords) {
      if (keyword.toLowerCase().contains(lowerQuery)) score += 8;
    }

    return score;
  }

  String getRelevantContext(String query) {
    final relevantItems = searchKnowledgeBase(query);
    
    if (relevantItems.isEmpty) {
      return 'No specific information found in the knowledge base for this query.';
    }

    final context = StringBuffer();
    context.writeln('Relevant information from MGM Generator knowledge base:');
    context.writeln('');
    
    for (int i = 0; i < relevantItems.length; i++) {
      final item = relevantItems[i];
      context.writeln('${i + 1}. ${item.title} (${item.category})');
      context.writeln(item.content);
      if (i < relevantItems.length - 1) context.writeln('');
    }

    return context.toString();
  }

  List<String> getCategories() {
    if (!_isInitialized) return [];
    
    final categories = _knowledgeBase.map((item) => item.category).toSet().toList();
    categories.sort();
    return categories;
  }

  List<KnowledgeItem> getByCategory(String category) {
    if (!_isInitialized) return [];
    
    return _knowledgeBase.where((item) => 
        item.category.toLowerCase() == category.toLowerCase()).toList();
  }

  List<KnowledgeItem> getByKVARating(String kvaRating) {
    if (!_isInitialized) return [];
    
    return _knowledgeBase.where((item) => 
        item.kvaRating?.toLowerCase() == kvaRating.toLowerCase()).toList();
  }
}
