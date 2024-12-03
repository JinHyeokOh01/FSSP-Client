// lib/services/restaurant_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class RestaurantService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<void> addToFavorites(String restaurantName) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/db/savelist'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'NewItem': restaurantName}),
      );
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String restaurantName) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/db/deletelist'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'NewItem': restaurantName}),
      );
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