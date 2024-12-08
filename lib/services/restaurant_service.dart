import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';

class RestaurantService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static final RestaurantService _instance = RestaurantService._internal();
  
  factory RestaurantService() => _instance;
  RestaurantService._internal();

  void setCookie(String cookie) {
    _headers['Cookie'] = cookie;
  }

  void clearCookie() {
    _headers.remove('Cookie');
  }

  Future<bool> checkLoginStatus() async {
    try {
      // 로그인 상태 확인을 별도 Isolate에서 수행
      return await compute(_checkLoginStatus, {
        'headers': _headers,
        'baseUrl': baseUrl,
      });
    } catch (e) {
      print('Login status check error: $e');
      return false;
    }
  }

  // 로그인 상태 확인을 위한 Isolate 함수
  static Future<bool> _checkLoginStatus(Map<String, dynamic> data) async {
    try {
      final response = await http.get(
        Uri.parse(data['baseUrl'] + '/auth/current-user'),
        headers: data['headers'],
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> addToFavorites(Restaurant restaurant) async {
    try {
      // 즐겨찾기 추가 처리를 별도 Isolate에서 수행
      final result = await compute(_addToFavorites, {
        'restaurant': {
          'name': restaurant.name,
          'category': restaurant.category,
          'address': restaurant.address,
        },
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (result['error'] != null) {
        throw Exception(result['error']);
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // 즐겨찾기 추가를 위한 Isolate 함수
  static Future<Map<String, dynamic>> _addToFavorites(Map<String, dynamic> data) async {
    try {
      // 로그인 상태 확인
      final loginResponse = await http.get(
        Uri.parse(data['baseUrl'] + '/auth/current-user'),
        headers: data['headers'],
      );

      if (loginResponse.statusCode != 200) {
        return {'error': '로그인이 필요합니다.'};
      }

      final response = await http.post(
        Uri.parse(data['baseUrl'] + '/api/restaurants'),
        headers: data['headers'],
        body: json.encode(data['restaurant']),
      );

      if (response.statusCode != 200) {
        return {
          'error': 'Failed to add to favorites: ${response.statusCode} - ${response.body}'
        };
      }

      return {'error': null};
    } catch (e) {
      return {'error': 'Error adding to favorites: $e'};
    }
  }

  Future<void> removeFromFavorites(String restaurantName) async {
    try {
      // 즐겨찾기 제거 처리를 별도 Isolate에서 수행
      final result = await compute(_removeFromFavorites, {
        'restaurantName': restaurantName,
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (result['error'] != null) {
        throw Exception(result['error']);
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // 즐겨찾기 제거를 위한 Isolate 함수
  static Future<Map<String, dynamic>> _removeFromFavorites(Map<String, dynamic> data) async {
    try {
      // 로그인 상태 확인
      final loginResponse = await http.get(
        Uri.parse(data['baseUrl'] + '/auth/current-user'),
        headers: data['headers'],
      );

      if (loginResponse.statusCode != 200) {
        return {'error': '로그인이 필요합니다.'};
      }

      final response = await http.delete(
        Uri.parse(data['baseUrl'] + '/api/restaurants'),
        headers: data['headers'],
        body: json.encode({'name': data['restaurantName']}),
      );

      if (response.statusCode != 200) {
        return {
          'error': 'Failed to remove from favorites: ${response.statusCode} - ${response.body}'
        };
      }

      return {'error': null};
    } catch (e) {
      return {'error': 'Error removing from favorites: $e'};
    }
  }

  // URL 실행은 UI 관련 작업이므로 메인 스레드에서 실행
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