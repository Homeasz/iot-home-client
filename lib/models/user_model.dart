// lib/models/user.dart
import 'dart:convert';

class User {
  final int id;
  final String email;
  User({
    required this.id,
    required this.email,
  });
  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
    };
  }
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
