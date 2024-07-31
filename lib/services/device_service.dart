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
        Uri.parse('$DEVICE_BASE_URL/devices/register'),
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
        print('Device added successfully');
      } else {
        print('Failed to add device');
      }
    }
  }

  Future<bool> switchStatus(String switchId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$DEVICE_BASE_URL/switch/status/$switchId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final status = jsonDecode(response.body)['status'];
        return status;
      } else {
        print('Failed to get switch status');
      }
    }
    return false;
  }

  Future<bool> toggleSwitch(String switchId, bool state) async {
    final token = await _authService.getToken();
    print( 'toggleSwitch: $switchId, $state');
    if (token != null) {
      final response = await http.put(
        Uri.parse('$DEVICE_BASE_URL/switch/toggle'),
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
        print(response.body);
        return body['status'];
      } else {
        print(response.body);
      }
    }
    return false;
  }

  Future<bool> deleteSwitch(String switchId) async {
    final token = await _authService.getToken();
    if (token == null) return false;
    final response = await http.delete(
      Uri.parse('$DEVICE_BASE_URL/switch/$switchId'),
      headers: <String, String>{
        'Cookie': token,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print('Switch deleted successfully');
      return true;
    } else {
      print('Failed to delete switch');
    }
    return false;
  }

  Future<SwitchModel?> editSwitch(String switchId, String switchName) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$DEVICE_BASE_URL/switch/$switchId'),
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
        print(response.body);
      }
    }
    return null;
  }

}
