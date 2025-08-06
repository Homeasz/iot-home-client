import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:homeasz/models/room_model.dart';
import 'package:provider/provider.dart';

class RoomsRepository {
  static RoomsRepository? _instance;

  RoomsRepository._internal();

  factory RoomsRepository() {
    _instance ??= RoomsRepository._internal();
    return _instance!;
  }

  static Box<Room>? roomsBox; //map of roomId and Room

  Future<void> saveRoomToDb(int roomId, Room room) async {
    roomsBox ??= await Hive.openBox<Room>('Rooms');
    if (roomsBox == null) {
      log("$TAG getRoomsFromDb - failed to open db");
      return;
    }
    roomsBox?.put(roomId, room);
  }

  Future<void> saveRoomsToDb(List<Room> rooms) async {
    roomsBox ??= await Hive.openBox<Room>('Rooms');
    if (roomsBox == null) {
      log("$TAG getRoomsFromDb - failed to open db");
      return;
    }
    for (Room room in rooms) {
      roomsBox?.put(room.id, room);
    }
  }

  Future<Room?> getRoomFromDb(int roomId) async {
    roomsBox ??= await Hive.openBox<Room>('Rooms');
    if (roomsBox == null) {
      log("$TAG getRoomsFromDb - failed to open db");
      return null;
    }
    Room? room = roomsBox!.get(roomId);
    return room;
  }

  Future<List<Room>?> getRoomsFromDb() async {
    log("$TAG getRoomsFromDb");
    roomsBox ??= await Hive.openBox<Room>('Rooms');
    if (roomsBox == null) {
      log("$TAG getRoomsFromDb - failed to open db");
      return null;
    }
    return roomsBox!.values.toList();
  }

  String TAG = "RoomsRepository:";
}
