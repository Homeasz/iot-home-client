// ignore_for_file: unused_import

import 'dart:core';
import 'dart:developer';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/utils/constants.dart';

class RoutineService {
  final _authService = AuthService();

  Future<List<RoutineCloudResponse>> getUserRoutines() async {
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
        return body.map((e) => RoutineCloudResponse.fromMap(e)).toList();
      }
    }
    return [];
  }

  Future<RoutineCloudResponse?> addRoutine(String name, String time, int repeat,
      List<Map<String, dynamic>> switches) async {
    log("$TAG $switches");
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$BASE_URL/routines'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'time': time,
          'repeat': repeat,
          'switches': switches,
        }),
      );
      log("$TAG ${jsonEncode(<String, dynamic>{
            'name': name,
            'time': time,
            'repeat': repeat,
            'switches': switches,
          })}");
      log("$TAG ${response.body.toString()}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        log("$TAG body: ${response.body}");
        log("$TAG decoded body: $body");
        log("$TAG body['data']: ${body['data']}");
        log("$TAG decoded body['data']: ${body['data']['id']}");
        return RoutineCloudResponse.fromMap(body['data']);
      }
    }
    return null;
  }

  String TAG = "RoutineService:";
}
