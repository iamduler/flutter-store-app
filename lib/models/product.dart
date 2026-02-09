import 'dart:convert';

class Product {
  final String id;
  final String name;
  final int price;
  final int quantity;
  final String vendorId;
  final String vendorName;
  final String category;
  final String subCategory;
  final bool? popular;
  final bool? recommend;
  final String? description;
  final List<dynamic> images;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.vendorId,
    required this.vendorName,
    required this.category,
    required this.subCategory,
    required this.images,
    this.popular = false,
    this.recommend = false,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'images': images,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'category': category,
      'subCategory': subCategory,
      'popular': popular,
      'recommend': recommend,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      images: json['images'] as List<dynamic>,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      popular: json['popular'] as bool,
      recommend: json['recommend'] as bool,
      description: json['description'] as String,
    );
  }
}
