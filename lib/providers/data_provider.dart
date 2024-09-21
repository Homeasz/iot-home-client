import 'dart:math';

import 'package:flutter/material.dart';
import 'package:homeasz/models/auth_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/services/device_service.dart';
import 'package:homeasz/services/room_service.dart';
import 'package:homeasz/services/user_service.dart';

class DataProvider extends ChangeNotifier {
  final RoomService roomService = RoomService();
  final DeviceService deviceService = DeviceService();

  List<Room> _rooms = [];
  List<SwitchModel> _switches = [];
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  List<Room> get rooms => _rooms;
  List<SwitchModel> get switches => _switches;

  Future<List<Room>?> getUserRooms() async {
    try {
      final rooms = await roomService.getUserRooms();
      if (rooms != null) {
        _rooms = rooms;
        notifyListeners();
      }
      return rooms;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<Room?> getRoom(String roomId) async {
    final room = await roomService.getRoom(roomId);
    return room;
  }

  Future addRoom(String name, String type) async {
    final room = await roomService.addRoom(name, type);
    if (room != null) {
      rooms.add(room);
      notifyListeners();
    }
  }

  Future editRoom(String roomId, String roomName) async {
    final response = await roomService.editRoom(roomId, roomName);
    // print(response);
    if (response != null) {
      final roomIndex =
          rooms.indexWhere((element) => element.id.toString() == roomId);
      if (roomIndex != -1) {
        rooms[roomIndex] = response;
        notifyListeners();
      }
    }
  }
  
  Future <List<SwitchModel>> getSwitches(String roomId) async {
    final switches = await roomService.getSwitches(roomId);
    if (switches != null) {
      _switches = switches;
      notifyListeners();
    }
    return switches;
  }

  Future toggleSwitch(String switchId, bool state) async {
    final switchStatus = await deviceService.toggleSwitch(switchId, state);
    if (switchStatus != null) {
      final switchIndex = _switches.indexWhere((element) => element.id.toString() == switchId);
      if (switchIndex != -1) {
        _switches[switchIndex].status = switchStatus; // Correctly update the state
        notifyListeners();
      }
    }
  }
  
  Future addSwitchBoard(int roomId, String name) async {
    
  }

  Future deleteSwitch(String switchId) async {
    final response = await deviceService.deleteSwitch(switchId);
    if (response) {
      _switches.removeWhere((element) => element.id.toString() == switchId);
      notifyListeners();
    }
  }

  Future editSwitch(String switchId, String switchName) async {
    final response = await deviceService.editSwitch(switchId, switchName);
    if (response != null) {
      final switchIndex =
          _switches.indexWhere((element) => element.id.toString() == switchId);
      if (switchIndex != -1) {
        _switches[switchIndex] = response;
        notifyListeners();
      }
    }
  }

}
