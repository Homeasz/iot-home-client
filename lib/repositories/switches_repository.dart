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

  static Box<Map<int,PowerSwitch>>? switchesBox; //map of switchId and powerswitch

  Future<void> saveSwitchToDb(int roomId, List<PowerSwitch> powerSwitchList) async {
    switchesBox ??= await Hive.openBox<Map<int,PowerSwitch>>('Switches');
    if(switchesBox == null) {
      log("TAG getSwitchesFromDb - failed to open db");
      return;
    }
    Map<int,PowerSwitch> switchesMap = switchesBox?.get(roomId) ?? {};
    for(PowerSwitch powerSwitch in powerSwitchList) {
      switchesMap.update(powerSwitch.id, (value) => powerSwitch, ifAbsent: () => powerSwitch);
    }
    switchesBox?.put(roomId, switchesMap);
  }

  Future<PowerSwitch?> getSwitchFromDb(int switchId) async {
    switchesBox ??= await Hive.openBox<Map<int,PowerSwitch>>('Switches');
    if(switchesBox == null) {
      log("TAG getSwitchesFromDb - failed to open db");
      return null;
    }
    PowerSwitch? powerSwitch;
    for(Map<int,PowerSwitch> switchesMap in switchesBox?.values ?? const Iterable.empty()){
      powerSwitch = switchesMap[switchId];
      if(powerSwitch != null) {
        log("$TAG getFromDb - returning ${powerSwitch.id}");
        return powerSwitch;
      }
    }
    return powerSwitch;
  }

  Future<List<PowerSwitch>?> getSwitchesFromDb(int roomId) async {
    switchesBox ??= await Hive.openBox<Map<int,PowerSwitch>>('Switches');
    if(switchesBox == null) {
      log("TAG getSwitchesFromDb - failed to open db");
      return null;
    }
    if(switchesBox!.containsKey(roomId)){
      return switchesBox?.get(roomId)?.values.toList();
    }
  }

  String TAG = "SwitchesRepository:";
}
