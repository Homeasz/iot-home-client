import 'package:flutter/material.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/switch_model.dart';
// ignore: unused_import
import 'package:homeasz/pages/home_page.dart';
import 'package:homeasz/repositories/repository.dart';
import 'package:homeasz/services/device_service.dart';
import 'package:homeasz/services/room_service.dart';
import 'package:homeasz/services/routine_service.dart';

class DataProvider extends ChangeNotifier {
  final RoomService roomService = RoomService();
  final DeviceService deviceService = DeviceService();
  final RoutineService routineService = RoutineService();

  List<Room> _rooms = [];
  List<PowerSwitch> _switches = [];
  final List<PowerSwitch> _homePageSwitches = [];
  List<Routine> _routines = [];
  String? _errorMessage;
  late int _currentRoom = 0;
  List<PowerSwitch> _selectedSwitches = []; // for routines

  String? get errorMessage => _errorMessage;
  int get currentRoom => _currentRoom;
  List<Room> get rooms => _rooms;
  List<PowerSwitch> get homePageSwitches => _homePageSwitches;
  List<PowerSwitch> get switches => _switches;
  List<Routine> get routines => _routines;
  List<PowerSwitch> get selectedSwitches => _selectedSwitches;

  set currentRoom(int value) {
    _currentRoom = value;
  }

  set selectedSwitches(List<PowerSwitch> value) {
    _selectedSwitches = value;
  }

  // add switch to selected switches
  void addSwitchToSelectedSwitches(PowerSwitch powerSwitch) {
    _selectedSwitches.add(powerSwitch);
    // print(powerSwitch.roomName);
    // print("Selected switches: $_selectedSwitches");
    notifyListeners();
  }

  void removeSwitchFromSelectedSwitches(PowerSwitch powerSwitch) {
    _selectedSwitches.remove(powerSwitch);
    notifyListeners();
  }

  Future<List<Room>?> getUserRooms() async {
    try {
      final rooms = await roomService.getUserRooms();
      if (rooms != null) {
        _rooms = rooms;
        notifyListeners();
      }
      updateRoomDevices();
      return rooms;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<void> updateRoomDevices() async {
    for (Room room in _rooms) {
      room = await getRoom(room.id) ?? room;
    }
    notifyListeners();
  }

  Future<List<Routine>> getUserRoutines() async {
    final routines = await routineService.getUserRoutines();
    currentRoom = 0;
    _routines = routines;
    notifyListeners();
    return routines;
  }

  Future<Room?> getRoom(int roomId) async {
    final room = await roomService.getRoom(roomId.toString());
    return room;
  }

  Future addRoom(String name, String type) async {
    final room = await roomService.addRoom(name, type);
    if (room != null) {
      rooms.add(room);
      notifyListeners();
    }
  }

  void addToHomePageSwitches(String roomName, PowerSwitch selectedSwitch) {
    selectedSwitch.roomName = roomName;
    _homePageSwitches.add(selectedSwitch);
    notifyListeners();
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

  Future<List<PowerSwitch>> getSwitches(int roomId, String roomName) async {
    roomId ??=
        rooms[rooms.indexWhere((element) => element.name == roomName)].id;

    final switches = await roomService.getSwitches(roomId, roomName);
    _currentRoom = roomId;
    _switches = switches;
    notifyListeners();
    return switches;
  }

  void clearSwitches() {
    _switches = [];
  }

  Future<bool> toggleSwitch(int switchId, bool state) async {
    final switchStatus = await deviceService.toggleSwitch(switchId, !state);
    final switchIndex =
        _switches.indexWhere((element) => element.id == switchId);
    if (switchIndex != -1) {
      _switches[switchIndex].status =
          switchStatus; // Correctly update the state
      notifyListeners();
    }
    return switchStatus;
  }

  Future<int?> addDevice(String deviceName, int roomId) async {
    final deviceModel = await OnboardedESPsRepository().getFromDb(deviceName) ??
        await deviceService.addDevice(deviceName, roomId);
    if (deviceModel != null) {
      return deviceModel.id;
    }
  }

  void addSwitchToHomePage(int index) {
    _homePageSwitches.add(_switches[index]);
  }

  Future deleteSwitch(int switchId) async {
    final response = await deviceService.deleteSwitch(switchId);
    if (response) {
      _switches.removeWhere((element) => element.id == switchId);
      notifyListeners();
    }
  }

  Future editSwitch(int switchId, String switchName, String roomName,
      String stringType) async {
    final PowerSwitch? response = await deviceService.editSwitch(
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

  void deleteFavourite(int switchId) {
    _homePageSwitches.removeWhere((element) => element.id == switchId);
    notifyListeners();
  }
}
