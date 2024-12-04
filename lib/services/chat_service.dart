import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant.dart';

class ChatService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  void setCookie(String cookie) {
    print('Setting cookie in ChatService: $cookie');
    _headers['Cookie'] = cookie;
    print('ChatService headers after setting cookie: $_headers');
  }

  void clearCookie() {
    print('Clearing cookie in ChatService');
    _headers.remove('Cookie');
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      print('ChatService request headers: $_headers');
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: _headers,
        body: json.encode({'message': message}),
      );

      final responseData = json.decode(response.body);
      print('Chat response status: ${response.statusCode}');
      print('Chat response data: $responseData');
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['response'] ?? '응답을 받지 못했습니다.'
        };
      } else {
        return {
          'success': false,
          'error': '서버 오류: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Chat error: $e');
      return {
        'success': false,
        'error': '네트워크 오류가 발생했습니다: $e'
      };
    }
  }

  Future<Map<String, dynamic>> searchRestaurants(String query) async {
    try {
      print('Search request headers: $_headers');
      print('Search query: $query');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/search').replace(
          queryParameters: {'query': query}
        ),
        headers: _headers,
      );

      print('Search response status: ${response.statusCode}');
      print('Search response body: ${response.body}');

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> restaurantData = responseData['restaurants'] ?? [];
        final restaurants = restaurantData.map((data) => Restaurant(
          name: data['name'] ?? '',
          address: data['address'] ?? '',
          category: data['category'] ?? '',
          isFavorite: data['isFavorite'] ?? false,
        )).toList();

        return {
          'success': true,
          'data': restaurants
        };
      } else {
        return {
          'success': false,
          'error': '서버 오류: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Search error: $e');
      return {
        'success': false,
        'error': '검색 중 오류가 발생했습니다: $e'
      };
    }
  }
}