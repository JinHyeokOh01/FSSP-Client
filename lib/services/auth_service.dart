import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../services/restaurant_service.dart';
import '../services/favorites_service.dart';
import '../services/chat_service.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };
  
  final RestaurantService _restaurantService;
  final FavoritesService _favoritesService;

  static final AuthService _instance = AuthService._internal(
    RestaurantService(),
    FavoritesService(),
  );
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal(this._restaurantService, this._favoritesService);

  // AuthService의 _updateCookie 메소드 수정
  void _updateCookie(String? cookie) {
    if (cookie != null) {
      print('Updating cookie in AuthService: $cookie');
      _headers['Cookie'] = cookie;
      _restaurantService.setCookie(cookie);
      _favoritesService.setCookie(cookie);
      ChatService().setCookie(cookie);  // ChatService에도 쿠키 전달
      print('AuthService headers after update: $_headers');
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
        return true;
      }
      
      print('Registration failed: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      print('Login request headers: $_headers');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Login response headers: ${response.headers}');
      if (response.statusCode == 200) {
        final cookies = response.headers['set-cookie'];
        print('Received cookies from login: $cookies');
        if (cookies != null) {
          _updateCookie(cookies);
          final responseData = json.decode(response.body);
          print('Login response data: $responseData');
          return true;
        }
      }
      
      print('Login failed: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        _headers.remove('Cookie');
        _restaurantService.clearCookie();
        _favoritesService.clearCookie();
        return true;
      }
      return false;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/current-user'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User(
          id: data['id'],
          email: data['email'],
          name: data['name'],
        );
      }
      
      if (response.statusCode == 401) {
        return null;
      }
      
      print('Get user error: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  Future<String> sendChatMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: _headers,
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['response'] ?? '응답을 받지 못했습니다.';
      }
      
      print('Chat error: ${response.statusCode} - ${response.body}');
      return '오류가 발생했습니다.';
    } catch (e) {
      print('Chat error: $e');
      return '서버 연결에 실패했습니다.';
    }
  }
}