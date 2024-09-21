// // lib/services/api_service.dart
import 'package:homeasz/models/device_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homeasz/models/switch_model.dart';
import '../utils/constants.dart';

class DeviceService {
  final _authService = AuthService();

  Future<void> addDevice(String deviceName, int roomId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$BASE_URL/device/register'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'deviceName': deviceName,
          'roomId': roomId,
        }),
      );
      if (response.statusCode == 200) {
      } else {
      }
    }
  }

  Future<bool> switchStatus(String switchId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$BASE_URL/switch/status/$switchId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final status = jsonDecode(response.body)['status'];
        return status;
      } else {
      }
    }
    return false;
  }

  Future<bool> toggleSwitch(String switchId, bool state) async {
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
        return body['status'];
      } else {
      }
    }
    return false;
  }

  Future<bool> deleteSwitch(String switchId) async {
    final token = await _authService.getToken();
    if (token == null) return false;
    final response = await http.delete(
      Uri.parse('$BASE_URL/switch/$switchId'),
      headers: <String, String>{
        'Cookie': token,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
    }
    return false;
  }

  Future<SwitchModel?> editSwitch(String switchId, String switchName) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$BASE_URL/switch/$switchId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'switchId': switchId,
          'switchName': switchName,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return SwitchModel.fromMap(body['switch']);
      } else {
      }
    }
    return null;
  }
}
