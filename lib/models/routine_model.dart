import 'dart:developer';

import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/models/utils/action_model.dart';
import 'package:homeasz/models/utils/timer_model.dart';
import 'package:homeasz/providers/data_provider.dart';

class RoutineSwitchUI {
  final Room room;
  final PowerSwitch powerSwitch;
  final ActionModel action;
  final TimerModel timer;

  RoutineSwitchUI({
    required this.room,
    required this.powerSwitch,
    required this.action,
    required this.timer,
  });
}

class RoutineUI {
  String routineName;
  String type;
  List<DayInWeek> repeatDays;
  TimeOfDay time;
  Map<int, RoutineSwitchUI> routineSwitches;

  RoutineUI(
      {required this.routineName,
      required this.type,
      required this.repeatDays,
      required this.time,
      required this.routineSwitches});
}

class RoutineSwitchCloudResponse {
  final int id;
  final bool action;
  final int revertDuration;

  RoutineSwitchCloudResponse({
    required this.id,
    required this.action,
    required this.revertDuration,
  });

  factory RoutineSwitchCloudResponse.fromMap(Map<String, dynamic> map) {
    return RoutineSwitchCloudResponse(
      id: map['switchId'] ?? -1,
      action: map['action'] ?? false,
      revertDuration: map['revertDuration'] ?? 0,
    );
  }
}

class RoutineCloudResponse {
  final int id;
  final String name;
  final int repeat;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RoutineSwitchCloudResponse> switches;
  final TimeOfDay time;
  final String type;

  RoutineCloudResponse({
    required this.id,
    required this.name,
    required this.repeat,
    required this.createdAt,
    required this.updatedAt,
    required this.switches,
    required this.time,
    this.type = 'morning',
  });

  factory RoutineCloudResponse.fromMap(Map<String, dynamic> map) {
    return RoutineCloudResponse(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      repeat: map['repeat'] ?? 0,
      type: map['type'] ?? 'morning',
      createdAt: DateTime.parse(map['createdAt']) ?? DateTime.now(),
      updatedAt: DateTime.parse(map['updatedAt'] ?? map['createdAt']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(":")[0]),
        minute: int.parse(map['time'].split(":")[1]),
      ),
      switches: (map['switches'] != null)
          ? List<RoutineSwitchCloudResponse>.from(
              map['switches'].map((x) {
                log("RoutineModel: map['switches'].map(x): $x");
                return RoutineSwitchCloudResponse.fromMap(x);
              }),
            )
          : [],
    );
  }
  String TAG = "RoutineModel:";
}
