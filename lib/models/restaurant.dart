class Restaurant {
  final String name;
  final String address;
  final double longitude;
  final double latitude;
  final List<String>? products;
  final String? id;

  Restaurant({
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
    this.products,
    this.id
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['location']?['coordinates']?[1] ?? 0.0,
      longitude: json['location']?['coordinates']?[0] ?? 0.0,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      id: json['_id'],  // handle optional id
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'location': {
        'longitude': longitude,
        'latitude': latitude,
      },
      'products': products,
    };
  }

  @override
  String toString() {
    return 'Restaurant(name: $name, address: $address, location: [$longitude,$latitude], products: $products , id: $id)';
  }
}
