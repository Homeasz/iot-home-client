import 'package:flutter/material.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:homeasz/providers/user_provider.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> login(BuildContext context, email, String password) async {
    // call the login API
    // if successful, set the user
    _user = await AuthService().login(email, password);
    if (_user != null) {
      Provider.of<UserProvider>(context, listen: false).getUser();
    }
    notifyListeners();
  }

  Future<void> signup(
      BuildContext context, String email, String password) async {
    // call the signup API
    // if successful, set the user
    try {
      _user = await AuthService().signup(email, password);
      if (_user != null) {
        Provider.of<UserProvider>(context, listen: false).getUser();
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await AuthService().logout();
    _user = null;
    notifyListeners();
  }

  Future<bool?> isAuthenticated() async {
    final isAuthenticated = await AuthService().isAuthenticated();
    return isAuthenticated;
  }
}
