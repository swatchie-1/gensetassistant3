import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://genset.com.my/wp-json/wc/v3';
  static const String _consumerKey = 'ck_38fc3568667dd08bc3ff2c9df83424b3368aa8db';
  static const String _consumerSecret = 'cs_6fc2278ff62b920b6cbf37edba066f4fa698cc31';

  static Future<List<Product>> fetchProducts({
    int perPage = 50,
    String? search,
    String? category,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'per_page': perPage.toString(),
        '_fields': 'id,name,price,permalink,images',
        'consumer_key': _consumerKey,
        'consumer_secret': _consumerSecret,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      // Build URL with query parameters
      Uri uri = Uri.parse('$_baseUrl/products');
      uri = uri.replace(queryParameters: queryParams);

      print('Fetching products from: $uri');

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
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: Invalid parameters');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed: Invalid API credentials');
      } else if (response.statusCode == 404) {
        throw Exception('Not found: No products available');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: Please try again later');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<Product?> fetchProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$id?consumer_key=$_consumerKey&consumer_secret=$_consumerSecret'),
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
        return Product.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/categories?consumer_key=$_consumerKey&consumer_secret=$_consumerSecret'),
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
        Uri.parse('$_baseUrl/products?per_page=1&consumer_key=$_consumerKey&consumer_secret=$_consumerSecret'),
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
