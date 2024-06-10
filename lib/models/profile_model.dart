import 'dart:convert';

class Profile {
  final String firstName;
  final String lastName; 
  final String email;
  final String phone;
  final String address;
  final String bio;
  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.bio,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      firstName: map['firstname'] ?? '',
      lastName: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      bio: map['bio'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'bio': bio,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json){
    return Profile.fromMap(json['profileDetails']);
  }
  String toJson() => json.encode(toMap());
}
