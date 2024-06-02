import 'package:flutter/material.dart';
import 'package:homeasz/models/user.dart';
import 'package:homeasz/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    // call the login API
    // if successful, set the user
    _user = await AuthService().login(email, password);
    notifyListeners();
  }
  Future<void> signup(String name, String email, String password) async {
    // call the signup API
    // if successful, set the user
    _user = await AuthService().signup(name, email, password);
    notifyListeners();
  }
}