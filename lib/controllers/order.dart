import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/global_variable.dart';
import 'package:store_app/models/order.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    required String paymentIntentId,
    required String paymentStatus,
    required String paymentMethod,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

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
        paymentIntentId: paymentIntentId,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
      );

      final http.Response response = await http.post(
        Uri.parse('$uri/api/orders'),
        body: order.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/$buyerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error loading orders: $e');
    }
  }

  Future<void> deleteOrder({required String orderId, required context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order deleted successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error deleting order: $e');
    }
  }

  // Count delivered orders
  Future<int> countDeliveredOrders({required String buyerId}) async {
    try {
      final orders = await loadOrders(buyerId: buyerId);
      int count = orders.where((order) => order.delivered == true).length;
      return count;
    } catch (e) {
      throw Exception('Error counting delivered orders: $e');
    }
  }

  // Create a payment intent
  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('$uri/api/orders/payment/test'),
        body: jsonEncode({'amount': amount.toString(), 'currency': currency}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  // Retrieve a payment intent
  Future<Map<String, dynamic>> getPaymentIntent({
    required BuildContext context,
    required String paymentIntentId,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$uri/api/orders/payment/$paymentIntentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting payment intent: $e');
    }
  }
}
