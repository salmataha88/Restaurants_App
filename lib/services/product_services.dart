import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApiProvider {
  final String baseUrl = 'http://10.0.2.2:3000/product'; 

  Future<List<Product>> fetchProductsForRestaurant(String restaurantId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/restaurant/$restaurantId'));

      print('Request URL: $baseUrl/restaurant/$restaurantId');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products: ${response.reasonPhrase}');
        throw Exception('Failed to load products: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Fetch error: $error');
      throw Exception('Failed to fetch products due to network error');
    }
  }

  Future<List<Product>> searchProducts(String productName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search?productName=$productName'));

      print('Request URL: $baseUrl/restaurant/$productName');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to search products: ${response.reasonPhrase}');
        throw Exception('Failed to search products ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to search products: $error');
      throw Exception('Failed to search products due to network error');
    }
  }

}
