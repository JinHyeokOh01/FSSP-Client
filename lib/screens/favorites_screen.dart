// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/favorites_service.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/restaurant_list_item.dart';
import '../utils/modal_utils.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<Restaurant> _favoriteRestaurants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final favorites = await _favoritesService.getFavoriteRestaurants();
      setState(() {
        _favoriteRestaurants = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('즐겨찾기 목록을 불러오는데 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 앱바
            Container(
              width: 412,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: const BoxDecoration(color: Color(0xFFCBF1BF)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Saved',
                    style: TextStyle(
                      color: Color(0xFF1D1B20),
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => ModalUtils.showProfileModal(context),
                  ),
                ],
              ),
            ),

            // 즐겨찾기 리스트
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _favoriteRestaurants.isEmpty
                  ? const Center(
                      child: Text(
                        '저장된 식당이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadFavorites,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _favoriteRestaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _favoriteRestaurants[index];
                          return RestaurantListItem(
                            restaurant: restaurant,
                            onFavoriteToggle: () async {
                              try {
                                await _favoritesService.removeFromFavorites(restaurant.name);
                                setState(() {
                                  _favoriteRestaurants.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('즐겨찾기에서 삭제되었습니다.')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('삭제 중 오류가 발생했습니다.')),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),

            // 하단 네비게이션
            const BottomNavigation(currentRoute: '/favorites'),
          ],
        ),
      ),
    );
  }
}