import 'package:hive/hive.dart';
part 'switch_model.g.dart';

@HiveType(typeId: 1)
class PowerSwitch {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  bool state;
  @HiveField(3)
  final String type;
  @HiveField(4)
  String? roomName;
  final DateTime createdAt;
  final DateTime updatedAt;

  PowerSwitch({
    required this.id,
    required this.name,
    required this.state,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.roomName,
  });

  factory PowerSwitch.fromMap(Map<String, dynamic> map) {
    return PowerSwitch(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      state: map['state'] ?? false,
      type: map['type'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt'] ?? map['createdAt']),
      roomName: map['roomName'] ?? '',
    );
  }

  bool get status => state;

  set status(bool status) {
    state = status;
  }
}
