class Product {
  final String name;
  final String details;
  final double price;
  final String? id;

  Product({
    required this.name,
    required this.details,
    required this.price,
    this.id
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      price: (json['price'] as num).toDouble(),
      id: json['_id'],  // handle optional id
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'Product(name: $name, details: $details, price: $price , id: $id)';
  }
}
