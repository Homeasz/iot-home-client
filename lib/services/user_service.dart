// a user service which fetches user data only if the user is authenticated
import 'dart:core';
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
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$BASE_URL/user/profile/'),
        headers: <String, String>{
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
        // if(true){
        // print(jsonDecode(response.body)["data"]);

        return User.fromJson(jsonDecode(response.body));
        // return Profile.fromJson('{"name": "John Doe", "email": "johndoe@gmail.com", "phone": "1234567890", "address": "123 Main St, New York, NY", "bio": "I am a software engineer"}');
      }
    }
    return null;
  }

  Future<User?> updateUser(User user) async {
    // update user data only if the user is authenticated
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$BASE_URL/user/profile/'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toMap()),
      );
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    }
    return null;
  }
}
