// ignore_for_file: unused_import

import 'dart:core';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/utils/constants.dart';

class RoutineService {
  final _authService = AuthService();

  Future<List<Routine>> getUserRoutines() async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$BASE_URL/user/routines'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body)['data'];
        return body.map((e) => Routine.fromMap(e)).toList();
      }
    }
    return [];
  }
}
