// // lib/services/api_service.dart
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class RoomService {
  final _authService = AuthService();

  Future<List<Room>?> getUserRooms() async {
    final token = await _authService.getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$BASE_URL/user/rooms/'),
        headers: <String, String>{
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
        // deserialize the response which has message and rooms
        final Map<String, dynamic> data = jsonDecode(response.body);
        // get the rooms from the response by parsing the json
        final List<dynamic> rooms = data['rooms'];
        // return the list of rooms
        return rooms.map((room) => Room.fromMap(room)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    }
    return null;
  }

  Future<Room?> getRoom(String roomId) async {
    try {
      final response =
          await http.get(Uri.parse('$ROOM_BASE_URL/rooms/$roomId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Room.fromJson(data['room']);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Room?> addRoom(String name) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$ROOM_BASE_URL/room/'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'roomName': name,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Room.fromMap(data['room']);
      } else {
        print(response.body);
      }
    }
    return null;
  }

  Future<List<SwitchModel>?> getSwitches(String roomId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$ROOM_BASE_URL/room/switches/$roomId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> switches = body['data'];
        return switches
            .map((switchData) => SwitchModel.fromMap(switchData))
            .toList();
      } else {
        print(response.body);
      }
    }
    return null;
  }

  Future<bool> toggleSwitch(String switchId, bool state) async {
    final token = await _authService.getToken();
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
