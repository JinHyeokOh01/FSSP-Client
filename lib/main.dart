// lib/main.dart
import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/home_screen.dart';
import './screens/result_screen.dart';
import './screens/search_results_screen.dart';
import './screens/favorites_screen.dart';
import './models/restaurant.dart';
import './services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오뭐먹?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFCBF1BF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCBF1BF),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => FutureBuilder<bool>(
                future: _checkAuthStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (snapshot.data == true) {
                    return const HomeScreen();
                  }
                  
                  return const LoginScreen();
                },
              ),
            );
            
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
            
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          
          case '/home':
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: const RouteSettings(name: '/home'),
            );
          
          case '/result':
            if (settings.arguments == null) {
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            }
            
            if (settings.arguments is! Map<String, dynamic>) {
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            }

            final args = settings.arguments as Map<String, dynamic>;
            final message = args['message'];
            final response = args['response'];
            
            if (message == null || response == null || 
                message is! String || response is! String) {
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            }

            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                message: message,
                response: response,
              ),
              settings: const RouteSettings(name: '/result'),
            );
          
          case '/search-results':
            if (settings.arguments == null) {
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            }
            
            if (settings.arguments is! List<Restaurant>) {
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            }

            final restaurants = settings.arguments as List<Restaurant>;
            return MaterialPageRoute(
              builder: (_) => SearchResultsScreen(restaurants: restaurants),
              settings: const RouteSettings(name: '/search-results'),
            );
          
          case '/favorites':
            return MaterialPageRoute(
              builder: (_) => const FavoritesScreen(),
              settings: const RouteSettings(name: '/favorites'),
            );
          
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }

  Future<bool> _checkAuthStatus() async {
    final authService = AuthService();
    final user = await authService.getCurrentUser();
    return user != null;
  }
}