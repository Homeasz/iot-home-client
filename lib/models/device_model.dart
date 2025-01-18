import 'package:hive/hive.dart';
import 'package:homeasz/models/switch_model.dart';
part 'device_model.g.dart';

@HiveType(typeId: 0)
class DeviceModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int roomId;
  final String deviceType;
  @HiveField(3)
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
        (map['switches'] ?? []).map((x) => PowerSwitch.fromMap(x)),
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? "1970-01-01"),
      updatedAt: DateTime.parse(map['updatedAt'] ?? "1970-01-01"),
    );
  }
}
