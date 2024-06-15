import 'dart:convert';

class User {
  final String firstName;
  final String lastName; 
  final String email;
  final String phone;
  final String address;
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstname'] ?? '',
      lastName: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User.fromMap(json['profileDetails']);
  }
  String toJson() => json.encode(toMap());
}
