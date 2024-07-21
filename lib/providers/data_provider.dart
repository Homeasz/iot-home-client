import 'dart:math';

import 'package:flutter/material.dart';
import 'package:homeasz/models/auth_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/services/room_service.dart';
import 'package:homeasz/services/user_service.dart';

class DataProvider extends ChangeNotifier {
  final RoomService roomService = RoomService();

  List<Room> rooms = [];
  List<SwitchModel> switches = [];
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<List<Room>?> getUserRooms() async {
    try {
      final rooms = await roomService.getUserRooms();
      if (rooms != null) {
        this.rooms = rooms;
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

  Future addRoom(String name) async {
    final room = await roomService.addRoom(name);
    if (room != null) {
      rooms.add(room);
      notifyListeners();
    }
  }

  Future getSwitches(String roomId) async {
    final switches = await roomService.getSwitches(roomId);
    if (switches != null) {
      this.switches = switches;
      notifyListeners();
    }
  }

  Future toggleSwitch(String switchId, bool state) async {
    final switchStatus = await roomService.toggleSwitch(switchId, state);
    if (switchStatus != null) {
      final switchIndex =
          switches.indexWhere((element) => element.id.toString() == switchId);
      if (switchIndex != -1) {
        switches[switchIndex].status =
            switchStatus; // Correctly update the state
        notifyListeners();
      }
    }
  }
  Future addSwitchBoard(int roomId, String name) async {
    
  }

  Future deleteSwitch(String switchId) async {
    final response = await roomService.deleteSwitch(switchId);
    if (response) {
      switches.removeWhere((element) => element.id.toString() == switchId);
      notifyListeners();
    }
  }

  Future editSwitch(String switchId, String switchName) async {
    final response = await roomService.editSwitch(switchId, switchName);
    if (response != null) {
      final switchIndex =
          switches.indexWhere((element) => element.id.toString() == switchId);
      if (switchIndex != -1) {
        switches[switchIndex] = response;
        notifyListeners();
      }
    }
  }

}
