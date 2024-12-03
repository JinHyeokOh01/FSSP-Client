// lib/models/restaurant.dart
class Restaurant {
  final String name;
  final String category;
  final String address;
  bool isFavorite;
  
  Restaurant({
    required this.name,
    required this.category,
    required this.address,
    this.isFavorite = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'isFavorite': isFavorite,
    };
  }
}