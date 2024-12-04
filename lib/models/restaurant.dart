// lib/models/restaurant.dart
class Restaurant {
  final String name;
  final String address;
  final String category;
  bool isFavorite;

  Restaurant({
    required this.name,
    required this.address,
    required this.category,
    this.isFavorite = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      category: json['category'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}