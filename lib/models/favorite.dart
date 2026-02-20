import 'dart:convert';
class Favorite {
  final String productName;
  final int productPrice;
  final String category;
  final String image;
  final String vendorId;
  final String vendorName;
  final String productId;

  Favorite({
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.image,
    required this.vendorId,
    required this.vendorName,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'image': image,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'productId': productId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      productName: json['productName'] as String,
      productPrice: json['productPrice'] as int,
      category: json['category'] as String,
      image: json['image'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      productId: json['productId'] as String,
    );
  }
}
