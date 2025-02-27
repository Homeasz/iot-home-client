import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:homeasz/models/routine_model.dart';
import 'package:provider/provider.dart';

class RoutinesRepository {
  static RoutinesRepository? _instance;

  RoutinesRepository._internal();

  factory RoutinesRepository() {
    _instance ??= RoutinesRepository._internal();
    return _instance!;
  }

  static Box<RoutineCloudResponse>?
      routinesBox; //map of routineId and RoutineCloudResponse

  Future<void> saveRoutineToDb(
      int routineId, RoutineCloudResponse routine) async {
    routinesBox ??= await Hive.openBox<RoutineCloudResponse>('Routines');
    if (routinesBox == null) {
      log("$TAG getRoutinesFromDb - failed to open db");
      return;
    }
    routinesBox?.put(routineId, routine);
  }

  Future<void> saveRoutinesToDb(Map<int, RoutineCloudResponse> routines) async {
    routinesBox ??= await Hive.openBox<RoutineCloudResponse>('Routines');
    if (routinesBox == null) {
      log("$TAG getRoutinesFromDb - failed to open db");
      return;
    }
    for (RoutineCloudResponse routine in routines.values) {
      routinesBox?.put(routine.id, routine);
    }
  }

  Future<RoutineCloudResponse?> getRoutineFromDb(int routineId) async {
    routinesBox ??= await Hive.openBox<RoutineCloudResponse>('Routines');
    if (routinesBox == null) {
      log("$TAG getRoutinesFromDb - failed to open db");
      return null;
    }
    RoutineCloudResponse? routine = routinesBox!.get(routineId);
    return routine;
  }

  Future<Map<int, RoutineCloudResponse>?> getRoutinesFromDb() async {
    log("$TAG getRoutinesFromDb");
    routinesBox ??= await Hive.openBox<RoutineCloudResponse>('Routines');
    if (routinesBox == null) {
      log("$TAG getRoutinesFromDb - failed to open db");
      return null;
    }
    return routinesBox?.toMap().cast<int, RoutineCloudResponse>();
  }

  Future<void> removeRoutineFromDb(int routineId) async {
    routinesBox ??= await Hive.openBox<RoutineCloudResponse>('Routines');
    if (routinesBox == null) {
      log("$TAG removeRoutineFromDb - failed to open db");
      return;
    }
    routinesBox!.delete(routineId);
    return;
  }

  String TAG = "RoutinesRepository:";
}
