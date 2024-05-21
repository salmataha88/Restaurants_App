import './product.dart';

class Restaurant {
  final String? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<Product> products;

  Restaurant({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.products,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // Parse the JSON data and return a new Restaurant object
    return Restaurant(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      latitude: json['location']['coordinates'][1],
      longitude: json['location']['coordinates'][0],
      products: (json['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
    );
  }
}