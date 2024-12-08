import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
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

  // 이 메소드는 UI 업데이트와 관련되어 있어서 메인 Isolate에서 실행되어야 함
  void _updateCookie(String? cookie) {
    if (cookie != null) {
      _headers['Cookie'] = cookie;
      _restaurantService.setCookie(cookie);
      _favoritesService.setCookie(cookie);
      ChatService().setCookie(cookie);
    }
  }

  // 회원가입시 비밀번호 해싱 등의 무거운 작업을 Isolate에서 처리
  Future<bool> register(String email, String password, String name) async {
    try {
      // 비밀번호 해싱을 별도 Isolate에서 처리
      final hashedPassword = await compute(_hashPassword, password);
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': hashedPassword,
          'name': name,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // 비밀번호 해싱 함수 (별도 Isolate에서 실행)
  static String _hashPassword(String password) {
    // 실제로는 더 복잡한 해싱 알고리즘을 사용해야 함
    return base64Encode(utf8.encode(password));
  }

  Future<bool> login(String email, String password) async {
    try {
      // 로그인 데이터 처리를 별도 Isolate에서 수행
      final loginResult = await compute(_processLogin, {
        'email': email,
        'password': password,
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (loginResult['success']) {
        _updateCookie(loginResult['cookies']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // 로그인 처리를 위한 별도 Isolate 함수
  static Future<Map<String, dynamic>> _processLogin(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(data['baseUrl'] + '/auth/login'),
        headers: data['headers'],
        body: json.encode({
          'email': data['email'],
          'password': data['password'],
        }),
      );

      return {
        'success': response.statusCode == 200,
        'cookies': response.headers['set-cookie'],
      };
    } catch (e) {
      return {'success': false, 'cookies': null};
    }
  }

  Future<bool> logout() async {
    try {
      // 로그아웃 처리를 별도 Isolate에서 수행
      final success = await compute(_processLogout, {
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (success) {
        _headers.remove('Cookie');
        await Future.wait([
          Future(() => _restaurantService.clearCookie()),
          Future(() => _favoritesService.clearCookie()),
        ]);
        return true;
      }
      return false;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // 로그아웃 처리를 위한 별도 Isolate 함수
  static Future<bool> _processLogout(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(data['baseUrl'] + '/auth/logout'),
        headers: data['headers'],
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      // 사용자 데이터 처리를 별도 Isolate에서 수행
      final userData = await compute(_fetchUserData, {
        'headers': _headers,
        'baseUrl': baseUrl,
      });

      if (userData != null) {
        return User(
          id: userData['id'],
          email: userData['email'],
          name: userData['name'],
        );
      }
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  // 사용자 데이터 조회를 위한 별도 Isolate 함수
  static Future<Map<String, dynamic>?> _fetchUserData(Map<String, dynamic> data) async {
    try {
      final response = await http.get(
        Uri.parse(data['baseUrl'] + '/auth/current-user'),
        headers: data['headers'],
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> sendChatMessage(String message) async {
    try {
      // 채팅 메시지 처리를 별도 Isolate에서 수행
      final response = await compute(_processChatMessage, {
        'message': message,
        'headers': _headers,
        'baseUrl': baseUrl,
      });
      
      return response ?? '오류가 발생했습니다.';
    } catch (e) {
      return '서버 연결에 실패했습니다.';
    }
  }

  // 채팅 메시지 처리를 위한 별도 Isolate 함수
  static Future<String?> _processChatMessage(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(data['baseUrl'] + '/chat'),
        headers: data['headers'],
        body: json.encode({'message': data['message']}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}