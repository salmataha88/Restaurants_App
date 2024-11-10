import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class RestaurantApiProvider {
  final String baseUrl = 'http://10.0.2.2:3000/restaurant'; // Update with your IP if needed

  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));

      print('Request URL: $baseUrl/');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          List<dynamic> data = json.decode(response.body);
          print('Response Body: $data');

          return data.map((json) => Restaurant.fromJson(json)).toList();
        } catch (jsonError) {
          print('JSON Parsing error: $jsonError');
          throw Exception('Failed to parse response');
        }
      } else {
        print('Failed to load restaurants: ${response.reasonPhrase}');
        throw Exception('Failed to load restaurants: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Signup error: $error');
      throw Exception('Failed to load restaurants due to network error');
    }
  }


    Future<List<Restaurant>> getRestaurantsByProduct(String productName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/?productName=$productName'));

      print('Request URL: $baseUrl/search?productName=$productName');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        print('Failed to search restaurants: ${response.reasonPhrase}');
        throw Exception('Failed to search restaurants ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to search restaurants: $error');
      throw Exception('Failed to search restaurants due to network error');
    }
  }

}
