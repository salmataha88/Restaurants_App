import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiProvider {
  final String baseUrl = 'http://10.0.2.2:3000/user'; // Update with your IP if needed

  Future<User> signup(User user) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      print('Request URL: $baseUrl/signup');
      print('Request Body: ${json.encode(user.toJson())}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('==========================response');
        try {
          final jsonResponse = json.decode(response.body);
          print('Parsed JSON Response: $jsonResponse');

          final newUser = User.fromJson(jsonResponse);
          print('Signup successful: $newUser');
          return newUser;
        } catch (jsonError) {
          print('JSON Parsing error: $jsonError');
          throw Exception('Failed to parse signup response');
        }
      } else {
        print('Failed to signup: ${response.reasonPhrase}');
        throw Exception('Failed to signup: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Signup error: $error');
      throw Exception('Failed to signup due to network error');
    }
  }
}
