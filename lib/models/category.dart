import 'dart:convert';

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String banner;

  CategoryModel({required this.id, required this.name, required this.image, required this.banner});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image, 
      'banner': banner,
    };
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      banner: json['banner'] as String,
    );
  }
}

