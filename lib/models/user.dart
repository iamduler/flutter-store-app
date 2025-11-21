import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String gender;
  final String password;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.gender,
    required this.password,
    required this.token,
  });

  // Convert User object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'gender': gender,
      'password': password,
      'token': token,
    };
  }

  // Convert Map<String, dynamic> to JSON string
  String toJson() => json.encode(toMap());

  // Convert Map<String, dynamic> to User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      address: map['address'] as String? ?? "",
      gender: map['gender'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }

  // Convert JSON string to User object
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
