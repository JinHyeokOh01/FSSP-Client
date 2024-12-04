import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';

class RestaurantService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static final RestaurantService _instance = RestaurantService._internal();
  
  factory RestaurantService() {
    return _instance;
  }
  
  RestaurantService._internal();

  void setCookie(String cookie) {
    _headers['Cookie'] = cookie;
  }

  void clearCookie() {
    _headers.remove('Cookie');
  }

  // 로그인 상태 확인
  Future<bool> checkLoginStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/current-user'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Login status check error: $e');
      return false;
    }
  }

  Future<void> addToFavorites(Restaurant restaurant) async {
    try {
      // 로그인 상태 확인
      final isLoggedIn = await checkLoginStatus();
      if (!isLoggedIn) {
        throw Exception('로그인이 필요합니다.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: _headers,
        body: json.encode({
          'name': restaurant.name,
          'category': restaurant.category,
          'address': restaurant.address,
        }),
      );

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add to favorites: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // removeFromFavorites도 비슷하게 수정
  Future<void> removeFromFavorites(String restaurantName) async {
    try {
      // 로그인 상태 확인
      final isLoggedIn = await checkLoginStatus();
      if (!isLoggedIn) {
        throw Exception('로그인이 필요합니다.');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: _headers,
        body: json.encode({'name': restaurantName}),
      );

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to remove from favorites: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  Future<void> openInNaverMap(String restaurantName) async {
    final url = Uri.encodeFull(
      'https://map.naver.com/v5/search/$restaurantName'
    );
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}