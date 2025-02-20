import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:provider/provider.dart';

class SwitchesRepository {
  static SwitchesRepository? _instance;

  SwitchesRepository._internal();

  factory SwitchesRepository() {
    _instance ??= SwitchesRepository._internal();
    return _instance!;
  }

  static Box<Map>? switchesBox; //map of switchId and powerswitch
  static Box<PowerSwitch>?
      favouriteSwitchesBox; //map of Favourite switchId and powerswitch
  Future<void> saveSwitchToDb(int roomId, PowerSwitch powerSwitch) async {
    switchesBox ??= await Hive.openBox<Map>('Switches');
    if (switchesBox == null) {
      log("$TAG saveSwitchToDb - failed to open db");
      return;
    }
    var entry = switchesBox!.get(roomId);
    Map<int, PowerSwitch>? switchesMap;
    if (entry is Map<dynamic, dynamic>) {
      switchesMap = entry.cast<int, PowerSwitch>();
      switchesMap[powerSwitch.id] = powerSwitch;
      switchesBox?.put(roomId, switchesMap);
    } else {
      log("$TAG saveSwitchToDb - roomId $roomId not found in db");
      switchesMap = {};
      switchesMap[powerSwitch.id] = powerSwitch;
      switchesBox?.put(roomId, switchesMap);
    }
  }

  Future<void> saveSwitchesToDb(
      int roomId, List<PowerSwitch> powerSwitchList) async {
    switchesBox ??= await Hive.openBox<Map>('Switches');
    if (switchesBox == null) {
      log("$TAG saveSwitchToDb - failed to open db");
      return;
    }
    var entry = switchesBox!.get(roomId);
    Map<int, PowerSwitch>? switchesMap;
    if (entry is Map<dynamic, dynamic>) {
      log("$TAG saveSwitchToDb - roomId $roomId found in db");
      switchesMap = entry.cast<int, PowerSwitch>();
      for (PowerSwitch powerSwitch in powerSwitchList) {
        switchesMap.update(powerSwitch.id, (value) => powerSwitch,
            ifAbsent: () => powerSwitch);
      }
      switchesBox?.put(roomId, switchesMap);
    } else {
      log("$TAG saveSwitchToDb - roomId $roomId not found in db");
      switchesMap = {};
      for (PowerSwitch powerSwitch in powerSwitchList) {
        switchesMap[powerSwitch.id] = powerSwitch;
      }
      switchesBox?.put(roomId, switchesMap);
    }
  }

  Future<PowerSwitch?> getSwitchFromDb(int switchId) async {
    switchesBox ??= await Hive.openBox<Map>('Switches');
    if (switchesBox == null) {
      log("$TAG getSwitchFromDb - failed to open db");
      return null;
    }
    PowerSwitch? powerSwitch;
    Map<int, PowerSwitch>? switchesMap;
    for (var entry in switchesBox!.values) {
      switchesMap = entry.cast<int, PowerSwitch>();
      powerSwitch = switchesMap[switchId];
      if (powerSwitch != null) {
        log("$TAG getFromDb - returning ${powerSwitch.id}");
        return powerSwitch;
      }
    }
    return powerSwitch;
  }

  Future<List<PowerSwitch>?> getSwitchesFromDb(int roomId) async {
    switchesBox ??= await Hive.openBox<Map<int, PowerSwitch>>('Switches');
    if (switchesBox == null) {
      log("$TAG getSwitchesFromDb - failed to open db");
      return null;
    }
    if (switchesBox!.containsKey(roomId)) {
      return switchesBox?.get(roomId)?.cast<int, PowerSwitch>().values.toList();
    }
    return null;
  }

//todo: save fav switches as list simply; instead of map with roomid
  Future<void> saveFavouriteSwitchToDb(PowerSwitch powerSwitch) async {
    favouriteSwitchesBox ??=
        await Hive.openBox<PowerSwitch>('FavouriteSwitches');
    if (favouriteSwitchesBox == null) {
      log("$TAG saveFavouriteSwitchToDb - failed to open db");
      return;
    }
    favouriteSwitchesBox!.put(powerSwitch.id, powerSwitch);
  }

  Future<void> saveFavouriteSwitchesToDb(
      List<PowerSwitch> powerSwitchList) async {
    favouriteSwitchesBox ??=
        await Hive.openBox<PowerSwitch>('FavouriteSwitches');
    if (favouriteSwitchesBox == null) {
      log("$TAG saveFavouriteSwitchesToDb - failed to open db");
      return;
    }
    for (PowerSwitch powerSwitch in powerSwitchList) {
      favouriteSwitchesBox!.put(powerSwitch.id, powerSwitch);
    }
  }

  Future<PowerSwitch?> getFavouriteSwitchFromDb(int switchId) async {
    favouriteSwitchesBox ??=
        await Hive.openBox<PowerSwitch>('FavouriteSwitches');
    if (favouriteSwitchesBox == null) {
      log("$TAG getFavouriteSwitchFromDb - failed to open db");
      return null;
    }
    return favouriteSwitchesBox!.get(switchId);
  }

  Future<List<PowerSwitch>?> getFavouriteSwitchesFromDb() async {
    favouriteSwitchesBox ??=
        await Hive.openBox<PowerSwitch>('FavouriteSwitches');
    if (favouriteSwitchesBox == null) {
      log("$TAG getFavouriteSwitchesFromDb - failed to open db");
      return null;
    }
    return favouriteSwitchesBox!.values.toList();
  }

  Future<void> removeFavouriteSwitchFromDb(int powerSwitchId) async {
    favouriteSwitchesBox ??=
        await Hive.openBox<PowerSwitch>('FavouriteSwitches');
    if (favouriteSwitchesBox == null) {
      log("$TAG saveFavouriteSwitchToDb - failed to open db");
      return;
    }
    favouriteSwitchesBox!.delete(powerSwitchId);
  }

  String TAG = "SwitchesRepository:";
}
