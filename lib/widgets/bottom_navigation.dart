import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final String currentRoute;

  const BottomNavigation({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      decoration: const BoxDecoration(
        color: Color(0xFFCBF1BF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: Icons.home,
              label: 'Home',
              route: '/home',
              isSelected: currentRoute == '/home',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context: context,
              icon: Icons.star,
              label: 'Saved',
              route: '/favorites',
              isSelected: currentRoute == '/favorites',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF1D1B20) : const Color(0xFF49454F),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1D1B20) : const Color(0xFF49454F),
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}