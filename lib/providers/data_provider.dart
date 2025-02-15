import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';
import 'package:homeasz/models/device_model.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/models/utils/action_model.dart' as action_model;
import 'package:homeasz/models/utils/timer_model.dart' as timer_model;
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
  Map<int, RoutineUI> _routinesUI = {};
  String? _errorMessage;
  late int _currentRoom = 0;

  String? get errorMessage => _errorMessage;
  int get currentRoom => _currentRoom;
  List<Room> get rooms => _rooms;
  List<PowerSwitch> get homePageSwitches => _homePageSwitches;
  List<PowerSwitch> get switches => _switches;
  List<RoutineCloudResponse> get routines => _routines;
  Map<int, RoutineUI> get routinesUI => _routinesUI;

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
      return rooms;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<void> updateRoomSwitches() async {
    for (Room room in _rooms) {
      room.switches = await getSwitches(room.id, room.name);
    }
    return;
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

  RoutineUI? getRoutineUI(int? routineId) {
    return (routineId != null && _routinesUI.containsKey(routineId))
        ? _routinesUI[routineId]
        : null;
  }

  Future<void> updateUserRoutinesUI() async {
    await getUserRooms();
    await updateRoomSwitches();
    for (RoutineCloudResponse routine in routines) {
      String routineName = routine.name;
      String type = "morning";
      int repeatDaysBitmask = routine.repeat;
      List<DayInWeek> repeatDays = [
        DayInWeek("M", dayKey: "monday"),
        DayInWeek("T", dayKey: "tuesday"),
        DayInWeek("W", dayKey: "wednesday"),
        DayInWeek("T", dayKey: "thursday"),
        DayInWeek("F", dayKey: "friday"),
        DayInWeek("S", dayKey: "saturday"),
        DayInWeek("S", dayKey: "sunday"),
      ];
      for (int i = 0; i < 7; i++) {
        repeatDays[(6 + i) % 7].isSelected = ((1 << i & repeatDaysBitmask) > 0);
      }
      TimeOfDay time = routine.time;
      Map<int, RoutineSwitchUI> routineSwitches = {};
      for (RoutineSwitchCloudResponse routineSwitch in routine.switches) {
        Room? room = getRoomIdFromSwitchId(routineSwitch.id);
        if (room == null) {
          log("$TAG No room exists for device");
          continue;
        }
        PowerSwitch? powerSwitch;
        powerSwitch = await getSwitch(room.id, routineSwitch.id);
        if (powerSwitch == null) {
          log("Couldn't get the switch with id ${routineSwitch.id}");
        }
        action_model.ActionModel action = action_model.ActionModel(
            action: (routineSwitch.action)
                ? action_model.Action.turnOn
                : action_model.Action.turnOff);
        timer_model.TimerModel timer = timer_model.TimerModel(
            timer: timer_model.intToTimer(routineSwitch.revertDuration));
        routineSwitches.putIfAbsent(
            routineSwitch.id,
            () => RoutineSwitchUI(
                room: room,
                powerSwitch: powerSwitch!,
                action: action,
                timer: timer));
      }
      _routinesUI.putIfAbsent(
          routine.id,
          () => RoutineUI(
              routineName: routineName,
              type: type,
              repeatDays: repeatDays,
              time: time,
              routineSwitches: routineSwitches));
    }
    log("Updated User Routines UI");
  }

  Room? getRoomFromId(int roomId) {
    return _rooms.firstWhere((element) => element.id == roomId);
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
    List<Map<String, dynamic>> switches = routine.routineSwitches.values
        .map((routineSwitch) => <String, dynamic>{
              'switchId': routineSwitch.powerSwitch.id,
              'action': routineSwitch.action.action.value,
              'revertDuration': "${routineSwitch.timer.timer.value}",
              'revertDurationUnit': "m"
            })
        .toList();
    RoutineCloudResponse? response =
        await routineService.addRoutine(name, time, repeat, switches);
    if (response != null) {
      _routines.add(response);
      notifyListeners();
      _routinesUI.putIfAbsent(response.id, () => routine);
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

  Room? getRoomIdFromSwitchId(int switchId) {
    log("SwitchId: $switchId rooms.size: ${rooms.length}");
    int roomIndex = rooms.indexWhere((element) {
      log("Room: ${element.name} element.size: ${element.switches.length}");
      for (PowerSwitch device in element.switches) {
        log("Room: ${element.name} SwitchId: $switchId device.id: ${device.id}");
        if (device.id == switchId) {
          return true;
        }
      }
      return false;
    });
    if (roomIndex >= 0) {
      return rooms[roomIndex];
    }
    return null;
  }

  Future<void> saveSwitchToDb(int? roomId, PowerSwitch powerSwitch) async {
    if (roomId != null) {
      SwitchesRepository().saveSwitchToDb(roomId, [powerSwitch]);
      return;
    }
    roomId = getRoomIdFromSwitchId(powerSwitch.id)?.id;
    if (roomId == null) {
      await getUserRooms();
      roomId = getRoomIdFromSwitchId(powerSwitch.id)?.id;
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
        log("$TAG Invalid SwitchId: $switchId");
        return powerSwitch;
      }
      saveSwitchToDb(roomId, powerSwitch);
    }
    return powerSwitch;
  }

  Future<List<PowerSwitch>> getSwitches(int? roomId, String roomName) async {
    if (roomId == null) {
      int roomIndex = rooms.indexWhere((element) => element.name == roomName);
      if (roomIndex >= 0) {
        roomId = rooms[roomIndex].id;
      } else {
        log("$TAG getSwitches - Room not found");
        return [];
      }
    }

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
