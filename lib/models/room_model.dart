import 'package:homeasz/models/device_model.dart';

class Room {
  final int id;
  final String name;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<DeviceModel> devices;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.devices,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      devices: List<DeviceModel>.from(
        (map['devices'] ?? []).map((x) => DeviceModel.fromMap(x)),
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
