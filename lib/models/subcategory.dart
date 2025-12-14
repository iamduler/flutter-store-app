import 'dart:convert';

class SubcategoryModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final String image;
  final String subCategoryName;

  SubcategoryModel({required this.id, required this.categoryId, required this.categoryName, required this.image, required this.subCategoryName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'image': image,
      'subCategoryName': subCategoryName,
    };
  }

  String toJson() => json.encode(toMap());

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['_id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      image: json['image'] as String,
      subCategoryName: json['subCategoryName'] as String,
    );
  }
}