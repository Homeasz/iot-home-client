import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:homeasz/models/device_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

/*
{
    "message": "Registered the device successfully",
    "device": {
        "id": 6,
        "name": "Device45",
        "deviceType": "ESP32",
        "roomId": 1,
        "createdAt": "2025-01-10T17:47:09.461Z",
        "updatedAt": "2025-01-10T17:47:09.461Z",
        "switches": [
            {
                "id": 11,
                "name": "Switch1",
                "state": false,
                "status": "ACTIVE",
                "type": "LIGHTBULB",
                "createdAt": "2025-01-10T17:47:09.472Z"
            },
            {
                "id": 12,
                "name": "Switch2",
                "state": false,
                "status": "ACTIVE",
                "type": "LIGHTBULB",
                "createdAt": "2025-01-10T17:47:09.472Z"
            }
        ]
    }
}
*/

class OnboardedESPsRepository {
  static OnboardedESPsRepository? _instance;

  OnboardedESPsRepository._internal();

  factory OnboardedESPsRepository() {
    _instance ??= OnboardedESPsRepository._internal();
    return _instance!;
  }

  static Box<DeviceModel>? devicesBox;

  Future<void> saveToDb(String deviceName, DeviceModel device) async {
    devicesBox ??= await Hive.openBox<DeviceModel>('Devices');
    devicesBox?.put(deviceName, device);
  }

  Future<DeviceModel?> getFromDb(String deviceName) async {
    devicesBox ??= await Hive.openBox<DeviceModel>('Devices');
    DeviceModel? deviceModel = devicesBox?.get(deviceName);
    log("$TAG getFromDb - returning ${deviceModel?.id}");
    return deviceModel;
  }

  String TAG = "OnboardedESPsRepository:";
}
