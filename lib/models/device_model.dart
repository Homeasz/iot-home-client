import 'package:homeasz/models/switch_model.dart';

class DeviceModel {
  final int id;
  final String name;
  final int roomId;
  final String deviceType;
  final List<PowerSwitch> switches;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.name,
    required this.roomId,
    required this.deviceType,
    required this.switches,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      roomId: map['roomId'] ?? 0,
      deviceType: map['deviceType'] ?? '',
      switches: List<PowerSwitch>.from(
        map['switches'].map((x) => PowerSwitch.fromMap(x)),
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
