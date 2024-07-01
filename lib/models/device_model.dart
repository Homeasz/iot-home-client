import 'package:homeasz/models/switch_model.dart';

class DeviceModel {
  final int id;
  final String name;
  final int roomId;
  final int numberOfSwitches;
  final List<SwitchModel> switches;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.name,
    required this.roomId,
    required this.numberOfSwitches,
    required this.switches,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      roomId: map['roomId'] ?? 0,
      numberOfSwitches: map['numberOfSwitches'] ?? 0,
      switches: List<SwitchModel>.from(
        map['switches'].map((x) => SwitchModel.fromMap(x)),
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
