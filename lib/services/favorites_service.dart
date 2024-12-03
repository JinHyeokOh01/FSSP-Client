// lib/services/favorites_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant.dart';

class FavoritesService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<List<Restaurant>> getFavoriteRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Restaurant.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print('Error getting favorites: $e');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String restaurantName) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': restaurantName}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }
}