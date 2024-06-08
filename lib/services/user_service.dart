// a user service which fetches user data only if the user is authenticated

import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/utils/constants.dart';


class UserService {
  // fetch user data only if the user is authenticated

  final _authService = AuthService();

  Future<User?> getUser() async {
    // fetch user data only if the user is authenticated
    final token = _authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$BASE_URL/user'),
        headers: <String, String>{
          'Cookie': token,
        },
      );
      
    } else {
      return null;
    }
  }

}