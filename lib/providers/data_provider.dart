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
import 'package:homeasz/repositories/favourites_repository.dart';
import 'package:homeasz/repositories/onboarded_esps_repository.dart';
import 'package:homeasz/repositories/rooms_repository.dart';
import 'package:homeasz/repositories/routines_repository.dart';
import 'package:homeasz/repositories/switches_repository.dart';
import 'package:homeasz/services/device_service.dart';
import 'package:homeasz/services/room_service.dart';
import 'package:homeasz/services/routine_service.dart';

class DataProvider extends ChangeNotifier {
  final RoomService roomService = RoomService();
  final DeviceService deviceService = DeviceService();
  final RoutineService routineService = RoutineService();

  List<Room> _rooms = [];
  Map<int, Map<int, PowerSwitch>> _switches = {}; //map of roomId and switches
  List<PowerSwitch> _homePageSwitches = [];
  List<dynamic> _homeWindowFavouriteTiles = [];
  List<RoutineCloudResponse> _routines = [];
  Map<int, RoutineUI> _routinesUI = {};
  String? _errorMessage;
  late int _currentRoom = 0;

  String? get errorMessage => _errorMessage;
  int get currentRoom => _currentRoom;
  List<Room> get rooms => _rooms;
  List<PowerSwitch> get homePageSwitches => _homePageSwitches;
  List<dynamic> get homeWindowFavouriteTiles => _homeWindowFavouriteTiles;
  Map<int, Map<int, PowerSwitch>> get switches => _switches;
  List<RoutineCloudResponse> get routines => _routines;
  Map<int, RoutineUI> get routinesUI => _routinesUI;

  set currentRoom(int value) {
    _currentRoom = value;
  }

  Future<void> dataSync() async {
    log("$TAG Data Sync");
    //sync favourites from db
    try {
      _homeWindowFavouriteTiles =
          await FavouritesRepository().getFavouritesTilesFromDb() ?? [];
      _homePageSwitches =
          await FavouritesRepository().getFavouriteSwitchesFromDb() ?? [];
      notifyListeners();
    } catch (e) {
      log("message: ${e.toString()}");
    }
    //sync rooms from db
    _rooms = await RoomsRepository().getRoomsFromDb() ?? [];
    //sync switches from db
    for (Room room in _rooms) {
      _switches[room.id] =
          await SwitchesRepository().getSwitchesFromDb(room.id) ?? {};
      room.switches = _switches[room.id]!.values.toList();
    }
    _routines = await RoutinesRepository().getRoutinesFromDb() ?? [];
    await updateUserRoutinesUI();

    dataSyncFromCloud();
  }

  Future<void> dataSyncFromCloud() async {
    //sync rooms from cloud async
    List<Room>? userRooms = await roomService.getUserRooms();
    if (userRooms == null) {
      log("$TAG Failed to get rooms from cloud");
      return;
    } else {
      RoomsRepository().saveRoomsToDb(userRooms);
    }
    //sync switches for each room from cloud
    for (Room room in userRooms) {
      await roomService
          .getSwitches(room.id, room.name)
          .then((List<PowerSwitch> switchesList) {
        if (switchesList.isEmpty) {
          log("$TAG Received empty switches list from cloud");
        }
        room.switches = switchesList;
        Map<int, PowerSwitch> switchesMap = {
          for (PowerSwitch powerSwitch in switchesList)
            powerSwitch.id: powerSwitch
        };
        _switches[room.id] = switchesMap;
        SwitchesRepository().saveSwitchesToDb(room.id, switchesMap);
        notifyListeners();
      });
    }

    //sync routines from cloud
    routineService
        .getUserRoutines()
        .then((List<RoutineCloudResponse> routines) {
      _routines = routines;
      notifyListeners();
      RoutinesRepository().saveRoutinesToDb(routines);
      updateUserRoutinesUI();
    });
  }

  Future<List<Room>?> getUserRooms() async {
    try {
      List<Room>? userRooms =
          rooms.isEmpty ? rooms : await RoomsRepository().getRoomsFromDb();
      if (userRooms == null) {
        userRooms = await roomService.getUserRooms();
        if (userRooms == null) {
          log("$TAG Failed to get rooms from cloud");
          return null;
        }
        RoomsRepository().saveRoomsToDb(userRooms);
      }
      _rooms = userRooms;
      notifyListeners();
      return userRooms;
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

  RoutineUI? getRoutineUI(int? routineId) {
    return (routineId != null && _routinesUI.containsKey(routineId))
        ? _routinesUI[routineId]
        : null;
  }

  Future<void> updateUserRoutinesUI() async {
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
        Room? room = getRoomFromSwitchId(routineSwitch.id);
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
              name: routineName,
              type: type,
              repeatDays: repeatDays,
              time: time,
              routineSwitches: routineSwitches));
    }
    log("Updated User Routines UI");
  }

  void updateHomeWindowFavouriteTiles(dynamic tileData) {
    _homeWindowFavouriteTiles.add(tileData);
    FavouritesRepository().saveFavouritesTileToDb(tileData);
    notifyListeners();
  }

  Room? getRoomFromId(int roomId) {
    return _rooms.firstWhere((element) => element.id == roomId);
  }

  Future<Room?> getRoom(int roomId) async {
    final room = await roomService.getRoom(roomId.toString());
    if (room == null) {
      log("$TAG getRoom - Room not found");
      return null;
    }
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
    FavouritesRepository().saveFavouriteSwitchToDb(selectedSwitch);
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
    String name = routine.name;
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
      RoutinesRepository().saveRoutineToDb(response.id, response);
      notifyListeners();
      _routinesUI.putIfAbsent(response.id, () => routine);
      return true;
    }
    return false;
  }

  Future editRoom(int roomId, String roomName) async {
    final response = await roomService.editRoom(roomId.toString(), roomName);
    // print(response);
    if (response != null) {
      final roomIndex = rooms.indexWhere((element) => element.id == roomId);
      if (roomIndex != -1) {
        rooms[roomIndex] = response;
        notifyListeners();
      }
    }
  }

  Room? getRoomFromSwitchId(int switchId) {
    for (int roomId in _switches.keys) {
      if (_switches[roomId]!.containsKey(switchId)) {
        return _rooms.firstWhere((element) => element.id == roomId);
      }
    }
    return null;
  }

  Future<void> saveSwitchToDb(int? roomId, PowerSwitch powerSwitch) async {
    if (roomId != null) {
      SwitchesRepository().saveSwitchToDb(roomId, powerSwitch);
      return;
    }
    roomId = getRoomFromSwitchId(powerSwitch.id)?.id;
    if (roomId == null) {
      await getUserRooms();
      roomId = getRoomFromSwitchId(powerSwitch.id)?.id;
    }
    if (roomId == null) {
      log("$TAG No roomId exists for device");
      return;
    }
    SwitchesRepository().saveSwitchToDb(roomId, powerSwitch);
  }

  Future<PowerSwitch?> getSwitch(int? roomId, int switchId) async {
    PowerSwitch? powerSwitch;
    if (roomId == null) {
      for (Map<int, PowerSwitch> switchList in _switches.values) {
        return switchList[switchId];
      }
    } else {
      powerSwitch = _switches[roomId]?[switchId];
      if (powerSwitch != null) {
        return powerSwitch;
      }
    }

    powerSwitch = await SwitchesRepository().getSwitchFromDb(switchId);
    if (powerSwitch == null) {
      powerSwitch = await deviceService.getSwitch(switchId);
      if (powerSwitch == null) {
        log("$TAG Invalid SwitchId: $switchId");
        return powerSwitch;
      }
      saveSwitchToDb(roomId, powerSwitch);
    } else {
      log("$TAG getSwitch - Switch found in db");
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
    _currentRoom = roomId;

    Map<int, PowerSwitch>? switchesList = switches[roomId];
    if (switchesList != null) {
      log("$TAG getSwitches - Switches found in cache");
      return switchesList.values.toList();
    }
    switchesList = await SwitchesRepository().getSwitchesFromDb(roomId);
    if (switchesList != null) {
      log("$TAG getSwitches - Switches found in db");
      _switches[roomId] = switchesList;
      notifyListeners();
      return switchesList.values.toList();
    }
    List<PowerSwitch>? switchList =
        await roomService.getSwitches(roomId, roomName);
    switchesList = {
      for (PowerSwitch powerSwitch in switchList) powerSwitch.id: powerSwitch
    };
    SwitchesRepository().saveSwitchesToDb(roomId, switchesList);
    _switches[roomId] = switchesList;
    notifyListeners();
    return switchList;
  }

  Future<bool> toggleSwitch(int switchId, bool state) async {
    final switchStatus = await deviceService.toggleSwitch(switchId, !state);
    for (Map<int, PowerSwitch> switchMap in _switches.values) {
      if (switchMap.containsKey(switchId)) {
        switchMap[switchId]!.state = switchStatus;
      }
    }
    for (PowerSwitch powerSwitch in _homePageSwitches) {
      if (powerSwitch.id == switchId) {
        powerSwitch.state = switchStatus;
      }
    }
    notifyListeners();
    return switchStatus;
  }

  Future<int?> addDevice(String deviceName, int roomId) async {
    final deviceModel = await OnboardedESPsRepository().getFromDb(deviceName) ??
        await deviceService.addDevice(deviceName, roomId);
    if (deviceModel != null) {
      return deviceModel.id;
    }
  }

  //TODO: fix this; _switches is now a list of switches for each room
  Future deleteSwitch(int switchId) async {
    final response = await deviceService.deleteSwitch(switchId);
    if (response) {
      for (Map<int, PowerSwitch> switchMap in _switches.values) {
        if (switchMap.containsKey(switchId)) {
          switchMap.remove(switchId);
        }
      }
      for (PowerSwitch powerSwitch in _homePageSwitches) {
        if (powerSwitch.id == switchId) {
          _homePageSwitches.remove(powerSwitch);
        }
      }
      notifyListeners();
    }
  }

  Future editSwitch(int switchId, String switchName, String roomName,
      String stringType) async {
    final PowerSwitch? response = await deviceService.editSwitch(
        switchId, switchName, roomName, stringType);
    if (response != null) {
      for (Map<int, PowerSwitch> switchMap in _switches.values) {
        switchMap[switchId] = response;
      }
      int index = _homePageSwitches
          .indexWhere((powerSwitch) => powerSwitch.id == response.id);
      if (index > -1) {
        _homePageSwitches[index] = response;
      }
      notifyListeners();
    }
  }

  void deleteFavourite(int switchId) {
    FavouritesRepository().removeFavouriteSwitchFromDb(switchId);
    _homePageSwitches.removeWhere((element) => element.id == switchId);
    notifyListeners();
  }

  String TAG = "DataProvider: ";
}
