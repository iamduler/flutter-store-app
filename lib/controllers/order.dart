import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/global_variable.dart';
import 'package:store_app/models/order.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'dart:convert';

class OrderController {
  uploadOrder({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int price,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required BuildContext context,
  }) async {
    try {
      final Order order = Order(
        id: id,
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        price: price,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
      );

      final http.Response response = await http.post(
        Uri.parse('$uri/api/orders'),
        body: order.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (!context.mounted) return;
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'You have placed an order successfully');
        },
      );
    } catch (e) {
      throw Exception('Error uploading order: $e');
    }
  }

  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/$buyerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else {        
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error loading orders: $e');
    }
  }
}
