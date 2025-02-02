// // lib/services/api_service.dart
import 'dart:developer';

import 'package:homeasz/models/device_model.dart';
import 'package:homeasz/repositories/onboarded_esps_repository.dart';
import 'package:homeasz/repositories/switches_repository.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/models/switch_model.dart';
import 'package:http/http.dart';
import '../utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceService {
  final _authService = AuthService();

  Future<DeviceModel?> addDevice(String deviceName, int roomId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$BASE_URL/device/register'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'roomId': roomId,
          'deviceName': deviceName,
          "switchCapacity": 4
        }),
      );
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        log("status: 201, response: ${response.body} ");
        DeviceModel device = DeviceModel.fromMap(body['device']);

        OnboardedESPsRepository().saveToDb(deviceName, device);

        return device;
      } else if (response.statusCode == 401) {
        log("status: 401, response: ${response.body} ");
        DeviceModel? device;
        if (body['error'] == "Room already has device with the same name") {
          device = await OnboardedESPsRepository().getFromDb(deviceName);
        }
        return device;
      }
    }
  }

  Future<Response?> switchDetails(int switchId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$BASE_URL/switch/status/$switchId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      return response;
    }
    return null;
  }

  Future<bool> switchStatus(int switchId) async {
    final Response? response = await switchDetails(switchId);
    if (response != null && response.statusCode == 200) {
      final status = jsonDecode(response.body)['status'];
      return status;
    }
    return false;
  }

  Future<PowerSwitch?> getSwitch(int switchId) async {
    final Response? response = await switchDetails(switchId);
    if (response != null && response.statusCode == 200) {
      final jsonDecoded = jsonDecode(response.body);
      final PowerSwitch powerSwitch = PowerSwitch(
          id: jsonDecoded['id'],
          name: jsonDecoded['name'],
          state: jsonDecoded['state'],
          type: jsonDecoded['type']);
      return powerSwitch;
    }
    return null;
  }

  Future<bool> toggleSwitch(int switchId, bool state) async {
    // print switch id and state
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$BASE_URL/switch/toggle'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'switchId': switchId,
          'toggleState': state,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data']['state'];
      } else {}
    }
    return false;
  }

  Future<bool> deleteSwitch(int switchId) async {
    final token = await _authService.getToken();
    if (token == null) return false;
    final response = await http.delete(
      Uri.parse('$BASE_URL/switch/$switchId'),
      headers: <String, String>{
        'Cookie': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'switchId': switchId,
        'toggleState': true,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {}
    return false;
  }

  Future<PowerSwitch?> editSwitch(int switchId, String switchName,
      String roomName, String switchType) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$BASE_URL/switch/'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'switchId': switchId,
          'newSwitchName': switchName,
          'type': switchType.toUpperCase(),
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return PowerSwitch.fromMap(body['data']);
      } else {}
    }
    return null;
  }
}
