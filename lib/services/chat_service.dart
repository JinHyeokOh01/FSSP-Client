// lib/services/chat_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response'] ?? '응답을 받지 못했습니다.';
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      return '오류가 발생했습니다: $e';
    }
  }

  // lib/services/chat_service.dart에 추가
  Future<String> searchRestaurants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/search').replace(
          queryParameters: {'query': query}
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response'] ?? '검색 결과가 없습니다.';
      } else {
        throw Exception('Failed to search restaurants');
      }
    } catch (e) {
      return '검색 중 오류가 발생했습니다: $e';
    }
  }
}