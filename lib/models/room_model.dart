class Room {
  final int id;
  final String name;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? 'BEDROOM',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt'] ?? map['createdAt']),
    );
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room.fromMap(json);
  }
}
