// // lib/services/api_service.dart

import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/constants.dart';

class RoomService {
  final _authService = AuthService();

  Future<List<Room>?> getLocalUserRooms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Room> rooms = prefs.get('rooms') as List<Room>;
    return rooms;
  }

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
        final List<dynamic> rooms = data['data'];
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
      final response = await http.get(Uri.parse('$BASE_URL/rooms/$roomId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Room.fromJson(data['room']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Room?> addRoom(String name, String type) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('$BASE_URL/room/'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'roomName': name,
          'type': type.toUpperCase(),
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Room.fromMap(data['data']);
      } else {}
    }
    return null;
  }

  Future<Room?> editRoom(String roomId, String roomName) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$BASE_URL/room/'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'roomId': int.parse(roomId),
          'roomName': roomName,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        data.forEach((key, value) {});
        return Room.fromMap(data["room"]);
      } else {}
    }
    return null;
  }

  Future<Room?> deleteRoom(String roomId) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.delete(
        Uri.parse('$BASE_URL/room/$roomId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Room.fromMap(data['room']);
      } else {}
    }
    return null;
  }

  Future<List<PowerSwitch>> getSwitches(int roomId, String? roomName) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$BASE_URL/room/switches/$roomId'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> switches = body['data'];
        switches.forEach((element) {
          element['roomName'] = roomName;
        });
        return switches
            .map((switchData) => PowerSwitch.fromMap(switchData))
            .toList();
      } else {
        return [];
      }
    }
    return [];
  }

  Future<bool> toggleRoom(int roomId, bool state) async {
    final token = await _authService.getToken();
    if (token != null) {
      final response = await http.put(
        Uri.parse('$BASE_URL/room/switches/toggle/all'),
        headers: <String, String>{
          'Cookie': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'roomId': roomId,
          'state': state,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data']['state'];
      } else {}
    }
    return false;
  }
}
