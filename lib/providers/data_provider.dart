import 'package:flutter/material.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/services/device_service.dart';
import 'package:homeasz/services/room_service.dart';

class DataProvider extends ChangeNotifier {
  final RoomService roomService = RoomService();
  final DeviceService deviceService = DeviceService();

  List<Room> _rooms = [];
  List<SwitchModel> _switches = [];
  String? _errorMessage;
  late int _currentRoom;

  String? get errorMessage => _errorMessage;
  int? get currentRoom => _currentRoom;
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

  Future<List<SwitchModel>> getSwitches(int roomId) async {
    final switches = await roomService.getSwitches(roomId);
    if (switches != null) {
      _currentRoom = roomId;
      _switches = switches;
      notifyListeners();
    }
    return switches;
  }

  Future toggleSwitch(int switchId, bool state) async {
    final switchStatus = await deviceService.toggleSwitch(switchId, state);
    if (switchStatus != null) {
      final switchIndex =
          _switches.indexWhere((element) => element.id.toString() == switchId);
      if (switchIndex != -1) {
        _switches[switchIndex].status =
            switchStatus; // Correctly update the state
        notifyListeners();
      }
    }
  }

  Future addDevice(String switchName, int roomId) async {
    final deviceModel = await deviceService.addDevice(switchName, roomId);
    if (deviceModel != null) {
      // _switches.add(deviceModel);
      // notifyListeners();
    }
  }

  Future deleteSwitch(String switchId) async {
    final response = await deviceService.deleteSwitch(switchId);
    if (response) {
      _switches.removeWhere((element) => element.id.toString() == switchId);
      notifyListeners();
    }
  }

  Future editSwitch(int switchId, String switchName, String roomName,
      String stringType) async {
    final SwitchModel? response = await deviceService.editSwitch(
        switchId, switchName, roomName, stringType);
    if (response != null) {
      final switchIndex =
          _switches.indexWhere((element) => element.id == switchId);
      if (switchIndex != -1) {
        _switches[switchIndex] = response;
      }
      notifyListeners();
    }
  }
}
