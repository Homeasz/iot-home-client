// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User?> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/signup'),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }
}

