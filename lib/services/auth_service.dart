// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  Future<bool?> isAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  String? getToken() {
    final SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    return prefs.getString('token');
  }

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response.headers['set-cookie']!);
      return User.fromJson(response.body);
    } else {
      return null;
    }
  }

  Future<User?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/auth/signup'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return User.fromJson(response.body);
    } else {
      throw Exception('User already exists, try signing in');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
