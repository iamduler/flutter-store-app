import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void setOrders(List<Order> orders) {
    state = orders;
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});