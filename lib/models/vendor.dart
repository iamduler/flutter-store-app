import 'dart:convert';

class VendorModel {
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String role;
  final String password;
  final String token;
  final String? image;
  final String? description;

  VendorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.role,
    required this.password,
    required this.token,
    this.image,
    this.description,
  });
  
  // Convert to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'role': role,
      'password': password,
      'token': token,
      'image': image,
      'description': description ?? '',
    };
  }

  String toJson() => json.encode(toMap());

  // Convert from map
  factory VendorModel.fromJson(Map<String, dynamic> map) {
    return VendorModel(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      address: map['address'] as String? ?? '',
      role: map['role'] as String? ?? '',
      password: map['password'] as String? ?? '',
      token: map['token'] as String? ?? '',
      image: map['image'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }
}
