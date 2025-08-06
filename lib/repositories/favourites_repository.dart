import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:provider/provider.dart';

class FavouritesRepository {
  static FavouritesRepository? _instance;

  FavouritesRepository._internal();

  factory FavouritesRepository() {
    _instance ??= FavouritesRepository._internal();
    return _instance!;
  }

  static Box<PowerSwitch>?
      favouriteSwitchesBox; //map of Favourite switchId and powerswitch
  static Box<dynamic>? favouriteTilesBox;

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

//Save favourite tiles

  Future<void> saveFavouritesTileToDb(dynamic tileData) async {
    favouriteTilesBox ??= await Hive.openBox<dynamic>('FavouritesTiles');
    if (favouriteTilesBox == null) {
      log("$TAG saveFavouritesTileToDb - failed to open db");
      return;
    }
    String tileKey = "${tileData.runtimeType}${tileData.id}";
    favouriteTilesBox!.put(tileKey, tileData);
  }

  Future<void> saveFavouritesTilesToDb(List<dynamic> tileDataList) async {
    favouriteTilesBox ??= await Hive.openBox<dynamic>('FavouritesTiles');
    if (favouriteTilesBox == null) {
      log("$TAG saveFavouritesTilesToDb - failed to open db");
      return;
    }
    for (dynamic tileData in tileDataList) {
      String tileKey = "${tileData.runtimeType}${tileData.id}";
      favouriteTilesBox!.put(tileKey, tileData);
    }
  }

  Future<dynamic> getFavouritesTileFromDb(int tileId, Type runtimeType) async {
    favouriteTilesBox ??= await Hive.openBox<dynamic>('FavouritesTiles');
    if (favouriteTilesBox == null) {
      log("$TAG getFavouritesTileFromDb - failed to open db");
      return null;
    }
    return favouriteTilesBox!.get("$runtimeType$tileId");
  }

  Future<List<dynamic>?> getFavouritesTilesFromDb() async {
    favouriteTilesBox ??= await Hive.openBox<dynamic>('FavouritesTiles');
    if (favouriteTilesBox == null) {
      log("$TAG getFavouritesTilesFromDb - failed to open db");
      return null;
    }
    return favouriteTilesBox!.values.toList();
  }

  Future<void> removeFavouritesTileFromDb(int tileId, Type runtimeType) async {
    favouriteTilesBox ??= await Hive.openBox<PowerSwitch>('FavouritesTiles');
    if (favouriteTilesBox == null) {
      log("$TAG saveFavouritesTileToDb - failed to open db");
      return;
    }
    favouriteTilesBox!.delete("$runtimeType$tileId");
  }

  String TAG = "FavouritesRepository:";
}
