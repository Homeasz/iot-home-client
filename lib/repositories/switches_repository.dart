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
    } else {
      log("$TAG saveSwitchToDb - roomId $roomId not found in db");
      switchesMap = {};
    }
    switchesMap[powerSwitch.id] = powerSwitch;
    switchesBox?.put(roomId, switchesMap);
  }

  Future<void> saveSwitchesToDb(
      int roomId, Map<int, PowerSwitch> powerSwitchList) async {
    switchesBox ??= await Hive.openBox<Map>('Switches');
    if (switchesBox == null) {
      log("$TAG saveSwitchToDb - failed to open db");
      return;
    }
    switchesBox?.put(roomId, powerSwitchList);
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

  Future<Map<int, PowerSwitch>?> getSwitchesFromDb(int roomId) async {
    switchesBox ??= await Hive.openBox<Map>('Switches');
    if (switchesBox == null) {
      log("$TAG getSwitchesFromDb - failed to open db");
      return null;
    }
    if (switchesBox!.containsKey(roomId)) {
      return switchesBox?.get(roomId)?.cast<int, PowerSwitch>();
    }
    return null;
  }

  String TAG = "SwitchesRepository:";
}
