import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';

class FavoritesService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static final FavoritesService _instance = FavoritesService._internal();
  
  factory FavoritesService() {
    return _instance;
  }
  
  FavoritesService._internal();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  void setCookie(String cookie) {
    _headers['Cookie'] = cookie;
  }

  void clearCookie() {
    _headers.remove('Cookie');
  }

  Future<List<Restaurant>> getFavoriteRestaurants() async {
    try {
      // 즐겨찾기 레스토랑 데이터 처리를 별도 Isolate에서 수행
      final result = await compute(_fetchFavorites, {
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (result['error'] != null) {
        throw Exception(result['error']);
      }

      return result['restaurants'] as List<Restaurant>;
    } catch (e) {
      print('FavoritesService error: $e');
      throw Exception('Failed to load favorites: $e');
    }
  }

  // 즐겨찾기 레스토랑 조회를 위한 Isolate 함수
  static Future<Map<String, dynamic>> _fetchFavorites(Map<String, dynamic> data) async {
    try {
      final response = await http.get(
        Uri.parse(data['baseUrl'] + '/api/restaurants'),
        headers: data['headers'],
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> restaurantsData = responseData['restaurants'];
        
        // 레스토랑 데이터 변환을 별도 Isolate에서 수행
        final restaurants = await compute(_convertRestaurants, restaurantsData);
        
        return {
          'restaurants': restaurants,
          'error': null,
        };
      } else if (response.statusCode == 401) {
        return {
          'restaurants': <Restaurant>[],
          'error': '로그인이 필요합니다',
        };
      } else {
        return {
          'restaurants': <Restaurant>[],
          'error': 'Failed to load favorites: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'restaurants': <Restaurant>[],
        'error': 'Failed to load favorites: $e',
      };
    }
  }

  // 레스토랑 데이터 변환을 위한 Isolate 함수
  static List<Restaurant> _convertRestaurants(List<dynamic> restaurantsData) {
    return restaurantsData.map((data) => Restaurant.fromJson({
      'name': data['Name'],
      'category': data['Category'],
      'address': data['Address'],
      'isFavorite': true,
    })).toList();
  }

  Future<void> removeFromFavorites(String restaurantName) async {
    try {
      // 즐겨찾기 제거 처리를 별도 Isolate에서 수행
      final result = await compute(_removeFavorite, {
        'restaurantName': restaurantName,
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (result['error'] != null) {
        throw Exception(result['error']);
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // 즐겨찾기 제거를 위한 Isolate 함수
  static Future<Map<String, dynamic>> _removeFavorite(Map<String, dynamic> data) async {
    try {
      final response = await http.delete(
        Uri.parse(data['baseUrl'] + '/api/restaurants'),
        headers: data['headers'],
        body: json.encode({'name': data['restaurantName']}),
      );

      if (response.statusCode != 200) {
        return {
          'error': 'Failed to remove from favorites: ${response.statusCode}',
        };
      }
      
      return {'error': null};
    } catch (e) {
      return {
        'error': 'Failed to remove from favorites: $e',
      };
    }
  }
}