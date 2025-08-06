import 'package:hive/hive.dart';
import 'package:homeasz/models/device_model.dart';
import 'package:homeasz/models/switch_model.dart';
part 'room_model.g.dart';

@HiveType(typeId: 2)
class Room {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @HiveField(3)
  List<DeviceModel> devices;
  @HiveField(4)
  List<PowerSwitch> switches;

  Room({
    required this.id,
    required this.name,
    required this.type,
    this.createdAt,
    this.updatedAt,
    required this.devices,
    required this.switches,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      devices: List<DeviceModel>.from(
        (map['devices'] ?? []).map((x) => DeviceModel.fromMap(x)),
      ),
      switches: List<PowerSwitch>.from(
        (map['switches'] ?? []).map((x) => PowerSwitch.fromMap(x)),
      ),
      type: map['type'] ?? 'BEDROOM',
      createdAt: DateTime.parse(map['createdAt'] ?? "1970-01-01"),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? map['createdAt'] ?? "1970-01-01"),
    );
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room.fromMap(json);
  }
}
