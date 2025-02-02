import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';
import 'package:homeasz/models/device_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/switch_model.dart';
// ignore: unused_import
import 'package:homeasz/pages/home_page.dart';
import 'package:homeasz/repositories/onboarded_esps_repository.dart';
import 'package:homeasz/repositories/switches_repository.dart';
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
  List<RoutineCloudResponse> _routines = [];
  String? _errorMessage;
  late int _currentRoom = 0;

  String? get errorMessage => _errorMessage;
  int get currentRoom => _currentRoom;
  List<Room> get rooms => _rooms;
  List<PowerSwitch> get homePageSwitches => _homePageSwitches;
  List<PowerSwitch> get switches => _switches;
  List<RoutineCloudResponse> get routines => _routines;

  set currentRoom(int value) {
    _currentRoom = value;
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

  Future<List<RoutineCloudResponse>> getUserRoutines() async {
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

  String formatTimeOfDay(TimeOfDay time) {
    final hour =
        time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // Convert 0 to 12
    final minute =
        time.minute.toString().padLeft(2, '0'); // Ensures 2-digit minutes
    final period = time.period == DayPeriod.am ? "AM" : "PM";

    return "$hour:$minute$period";
  }

  Future<bool> createRoutine(RoutineUI routine) async {
    String name = routine.routineName;
    String time = formatTimeOfDay(routine.time);
    int repeat = 0;
    int dayIndex = 1;
    for (DayInWeek day in routine.repeatDays) {
      //This logic is assuming repeatDays is a list of weekdays starting from Monday(1), Tuesday(2) to Sunday (0)
      if (day.isSelected) {
        repeat += 1 << dayIndex;
      }
      dayIndex = (dayIndex + 1) % 7;
    }
    List<Map<String,dynamic>> switches = routine.routineSwitches.values
        .map((routineSwitch) => <String,dynamic> {'switchId': routineSwitch.powerSwitch.id, 'action': routineSwitch.action.action.value, 'revertDuration': "${routineSwitch.timer.timer.value}",'revertDurationUnit': "h"})
        .toList();
    RoutineCloudResponse? response =
        await routineService.addRoutine(name, time, repeat, switches);
    if (response != null) {
      getUserRoutines();
      return true;
    }
    return false;
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

  int? getRoomIdFromSwitchId(switchId) {
    return rooms[rooms.indexWhere((element) {
      for (DeviceModel device in element.devices) {
        device.id == switchId;
        return true;
      }
      return false;
    })]
        .id;
  }

  Future<void> saveSwitchToDb(int? roomId, PowerSwitch powerSwitch) async {
    if (roomId != null) {
      SwitchesRepository().saveSwitchToDb(roomId, [powerSwitch]);
      return;
    }
    roomId = getRoomIdFromSwitchId(powerSwitch.id);
    if (roomId == null) {
      await getUserRooms();
      roomId = getRoomIdFromSwitchId(powerSwitch.id);
    }
    if (roomId == null) {
      log("$TAG No roomId exists for device");
      return;
    }
    SwitchesRepository().saveSwitchToDb(roomId, [powerSwitch]);
  }

  Future<PowerSwitch?> getSwitch(int? roomId, int switchId) async {
    PowerSwitch? powerSwitch =
        await SwitchesRepository().getSwitchFromDb(switchId);
    if (powerSwitch == null) {
      powerSwitch = await deviceService.getSwitch(switchId);
      if (powerSwitch == null) {
        log("$TAG Invalid SwitchId");
        return powerSwitch;
      }
      saveSwitchToDb(roomId, powerSwitch);
    }
    return powerSwitch;
  }

  Future<List<PowerSwitch>> getSwitches(int? roomId, String roomName) async {
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

  String TAG = "DataProvider: ";
}
