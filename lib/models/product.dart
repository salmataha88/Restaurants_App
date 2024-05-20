class Product {
  final String? id;
  final String name;
  final String details;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.details,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse the JSON data and return a new Product object
    return Product(
      id: json['_id'],
      name: json['name'],
      details: json['details'],
      price: json['price'].toDouble(),
    );
  }
}