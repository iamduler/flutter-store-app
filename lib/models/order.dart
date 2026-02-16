import 'dart:convert';

class Order {
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String phone;
  final String productName;
  final int price;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;

  Order({
    required this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phone,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'phone': phone,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'delivered': delivered,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      productName: map['productName'] as String,
      price: map['price'] as int,
      quantity: map['quantity'] as int,
      category: map['category'] as String,
      image: map['image'] as String,
      buyerId: map['buyerId'] as String,
      vendorId: map['vendorId'] as String,
      processing: map['processing'] as bool,
      delivered: map['delivered'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
