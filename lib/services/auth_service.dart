// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/models/auth_model.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  
  Future<bool?> isAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // print(token);
    if (token == null) return false;

    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<AuthUser?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawCookie = response.headers['set-cookie'];
      if (rawCookie != null) {
        final jwt = rawCookie.split(';').firstWhere((element) => element.contains('jwt='));
        prefs.setString('token', jwt);
      }
      // prefs.setString('token', response.headers['set-cookie']!);
      return AuthUser.fromJson(response.body);
    } else {
      print(response.body);
      return null;
    }
  }

  Future<AuthUser?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/auth/signup'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return AuthUser.fromJson(response.body);
    } else {
      throw Exception('User already exists, try signing in');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

}
