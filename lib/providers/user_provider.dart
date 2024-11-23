import 'package:flutter/material.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  final UserService userService = UserService();

  Future<void> getUser() async {
    final user = await userService.getUser();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> updateUser(User user) async {
    final updatedUser = await userService.updateUser(user);
    if (updatedUser != null) {
      _user = updatedUser;
      notifyListeners();
    }
  }
}
