import 'package:http/http.dart' as http;
import 'dart:convert';
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
    print('Setting cookie in FavoritesService: $cookie');
    _headers['Cookie'] = cookie;
    print('FavoritesService headers after setting cookie: $_headers');
  }

  void clearCookie() {
    print('Clearing cookie in FavoritesService');
    _headers.remove('Cookie');
    print('FavoritesService headers after clearing cookie: $_headers');
  }

  Future<List<Restaurant>> getFavoriteRestaurants() async {
    try {
      print('FavoritesService headers before request: $_headers');
      final response = await http.get(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: _headers,
      );
      print('FavoritesService response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('FavoritesService response data: $responseData');
        final List<dynamic> restaurants = responseData['restaurants'];
        return restaurants.map((data) => Restaurant.fromJson({
          'name': data['Name'],
          'category': data['Category'],
          'address': data['Address'],
          'isFavorite': true,
        })).toList();
      } else if (response.statusCode == 401) {
        print('FavoritesService unauthorized access');
        throw Exception('로그인이 필요합니다');
      } else {
        print('FavoritesService error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('FavoritesService error: $e');
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String restaurantName) async {
    try {
      print('FavoritesService removing restaurant: $restaurantName');
      print('Headers for remove request: $_headers');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: _headers,
        body: json.encode({'name': restaurantName}),
      );

      print('Remove favorite response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('Remove favorite error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to remove from favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}