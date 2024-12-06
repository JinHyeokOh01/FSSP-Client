// lib/widgets/restaurant_list_item.dart
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';

class RestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onFavoriteToggle;
  final RestaurantService _restaurantService = RestaurantService();

  RestaurantListItem({
    super.key, 
    required this.restaurant,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 즐겨찾기 아이콘
          Container(
            margin: const EdgeInsets.only(top: 0), // 아이콘을 위로 올림
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                restaurant.isFavorite ? Icons.star : Icons.star_border,
                color: Colors.black,
                size: 24,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),

          const SizedBox(width: 4),

          // 식당 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.category,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant.address,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // 네이버 지도 아이콘
          Container(
            width: 33,
            height: 33,
            margin: const EdgeInsets.only(left: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _restaurantService.openInNaverMap(restaurant.name),
              child: Image.asset(
                'assets/images/naver_map_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}