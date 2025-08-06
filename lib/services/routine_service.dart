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

  Future<Map<int, RoutineCloudResponse>> getUserRoutines() async {
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
        Map<int, RoutineCloudResponse> routineMap = {};
        for (var value in body) {
          RoutineCloudResponse routine = RoutineCloudResponse.fromMap(value);
          routineMap[routine.id] = routine;
        }
        return routineMap;
      }
    }
    return {};
  }

  Future<bool> removeRoutine(int routineId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.delete(
        Uri.parse('$BASE_URL/routines/$routineId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log("$TAG Routine removed");
        return true;
      }
    }
    return false;
  }

  Future<RoutineCloudResponse?> addRoutine(String name, String time, int repeat,
      List<Map<String, dynamic>> switches, int? routineId) async {
    final httpCall = (routineId != null) ? http.put : http.post;
    final uri = (routineId != null)
        ? '$BASE_URL/routines/$routineId'
        : '$BASE_URL/routines';
    log("$TAG $switches");
    final token = await _authService.getToken();
    if (token != null) {
      final response = await httpCall(
        Uri.parse(uri),
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
      log("$TAG addRoutine - uri:$uri body:${jsonEncode(<String, dynamic>{
            'name': name,
            'time': time,
            'repeat': repeat,
            'switches': switches,
          })}");
      log("$TAG addRoutine - ${response.body.toString()}");
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
