import 'dart:convert';

class Order {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String productName;
  final int price;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;
  final String paymentIntentId;
  final String paymentStatus;
  final String paymentMethod;

  Order({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
    required this.paymentIntentId,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'delivered': delivered,
      'paymentIntentId': paymentIntentId,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
    };
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      locality: json['locality'] as String,
      productName: json['productName'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      category: json['category'] as String,
      image: json['image'] as String,
      buyerId: json['buyerId'] as String,
      vendorId: json['vendorId'] as String,
      processing: json['processing'] as bool,
      delivered: json['delivered'] as bool,
      paymentIntentId: json['paymentIntentId'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
    );
  }
}
