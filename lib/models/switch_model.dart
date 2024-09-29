class SwitchModel {
  final int id;
  final String name;
  bool state;
  final DateTime createdAt;
  final DateTime updatedAt;

  SwitchModel({
    required this.id,
    required this.name,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SwitchModel.fromMap(Map<String, dynamic> map) {
    return SwitchModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      state: map['state'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']??map['createdAt']),
    );
  }

  bool get status => state;

  set status(bool status) {
    state = status;
  }
}
