import 'package:flutter/material.dart';
import 'package:homeasz/models/profile_model.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeasz/services/user_service.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  Profile? _profile;

  Profile? get profile => _profile;

  Future<void> getUser() async {
    final userService = UserService();
    final user = await userService.getUser();
    if (user != null) {
      _profile = user;
      notifyListeners();
    }
  }

  
}