// lib/services/chat_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      final responseData = json.decode(response.body);
      
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
      return {
        'success': false,
        'error': '네트워크 오류가 발생했습니다: $e'
      };
    }
  }

  Future<Map<String, dynamic>> searchRestaurants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/search').replace(
          queryParameters: {'query': query}
        ),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['response'] ?? '검색 결과가 없습니다.'
        };
      } else {
        return {
          'success': false,
          'error': '서버 오류: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': '검색 중 오류가 발생했습니다: $e'
      };
    }
  }
}