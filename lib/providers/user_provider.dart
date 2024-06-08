import 'package:flutter/material.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeasz/services/user_service.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    // call the login API
    // if successful, set the user
    _user = await UserService().login(email, password);
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    // call the signup API
    // if successful, set the user
    try {
      _user = await UserService().signup(email, password);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await UserService().logout();
    _user = null;
    notifyListeners();
  }

  Future<bool?> isAuthenticated() async {
    final isAuthenticated = await UserService().isAuthenticated();
    return isAuthenticated;
  }
}