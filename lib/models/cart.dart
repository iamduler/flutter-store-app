import 'dart:convert';
class Cart {
  final String productName;
  final int productPrice;
  final String category;
  final List<String> images;
  final String vendorId;
  final String vendorName;
  final int productQuantity;
  int quantity;
  final String productId;
  final String description;

  Cart({
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.images,
    required this.vendorId,
    required this.vendorName,
    required this.productQuantity,
    required this.quantity,
    required this.productId,
    required this.description,
  });

   Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'images': images,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'productQuantity': productQuantity,
      'quantity': quantity,
      'productId': productId,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(Map<String, dynamic> json) {
    final imagesRaw = json['images'];
    final images = imagesRaw is List
        ? List<String>.from(imagesRaw.map((e) => e.toString()))
        : <String>[];
    return Cart(
      productName: json['productName'] as String,
      productPrice: json['productPrice'] as int,
      category: json['category'] as String,
      images: images,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      productQuantity: json['productQuantity'] as int,
      quantity: json['quantity'] as int,
      productId: json['productId'] as String,
      description: json['description'] as String? ?? '',
    );
  }
}
