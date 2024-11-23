// lib/models/user.dart
import 'dart:convert';

class AuthUser {
  final int id;
  final String email;
  AuthUser({
    required this.id,
    required this.email,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
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

  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
