import 'package:flutter/material.dart';

class RoutineSwitch {
  final String id;
  final bool action;
  final int revertDuration;

  RoutineSwitch({
    required this.id,
    required this.action,
    required this.revertDuration,
  });

  factory RoutineSwitch.fromMap(Map<String, dynamic> map) {
    return RoutineSwitch(
      id: map['id'] ?? '',
      action: map['action'] ?? false,
      revertDuration: map['revertDuration'] ?? 0,
    );
  }
}

class Routine {
  final String name;
  final int repeat;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RoutineSwitch> switches;
  final TimeOfDay time;
  final String type;

  Routine({
    required this.name,
    required this.repeat,
    required this.createdAt,
    required this.updatedAt,
    required this.switches,
    required this.time,
    this.type = 'morning',
  });

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      name: map['name'] ?? '',
      repeat: map['repeat'] ?? 0,
      type: map['type'] ?? 'morning',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt'] ?? map['createdAt']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(":")[0]),
        minute: int.parse(map['time'].split(":")[1]),
      ),
      switches: List<RoutineSwitch>.from(
        map['switches'].map((x) => RoutineSwitch.fromMap(x)),
      ),
    );
  }
}
