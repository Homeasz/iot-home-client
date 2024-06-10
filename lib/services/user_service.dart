// a user service which fetches user data only if the user is authenticated
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/models/profile_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/utils/constants.dart';


class UserService {
  // fetch user data only if the user is authenticated

  final _authService = AuthService();

  Future<Profile?> getUser() async {
    // fetch user data only if the user is authenticated
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$BASE_URL/user/profile/details'),
        headers: <String, String>{
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
      // if(true){
        return Profile.fromJson(jsonDecode(response.body));
        // return Profile.fromJson('{"name": "John Doe", "email": "johndoe@gmail.com", "phone": "1234567890", "address": "123 Main St, New York, NY", "bio": "I am a software engineer"}');
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

}