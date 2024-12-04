// lib/screens/search_results_screen.dart
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/restaurant_list_item.dart';
import '../utils/modal_utils.dart';

class SearchResultsScreen extends StatefulWidget {
  final List<Restaurant> restaurants;

  const SearchResultsScreen({super.key, required this.restaurants});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final RestaurantService _restaurantService = RestaurantService();

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
                    '검색 결과',
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

            // 검색 결과 리스트
            Expanded(
              child: widget.restaurants.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = widget.restaurants[index];
                      return RestaurantListItem(
                        restaurant: restaurant,
                        // lib/screens/search_results_screen.dart 의 onFavoriteToggle 부분 수정
                        onFavoriteToggle: () async {
                          try {
                            if (restaurant.isFavorite) {
                              await _restaurantService.removeFromFavorites(restaurant.name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('즐겨찾기에서 삭제되었습니다.')),
                              );
                            } else {
                              await _restaurantService.addToFavorites(restaurant);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('즐겨찾기에 추가되었습니다.')),
                              );
                            }
                            setState(() {
                              restaurant.isFavorite = !restaurant.isFavorite;
                            });
                          } catch (e) {
                            String errorMessage = '오류가 발생했습니다.';
                            if (e.toString().contains('로그인이 필요합니다')) {
                              errorMessage = '로그인이 필요한 서비스입니다.';
                              // 로그인 페이지로 이동
                              Navigator.pushNamed(context, '/login');
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        },
                      );
                    },
                  ),
            ),

            // 하단 네비게이션
            const BottomNavigation(currentRoute: '/search-results'),
          ],
        ),
      ),
    );
  }
}