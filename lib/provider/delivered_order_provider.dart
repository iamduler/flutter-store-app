import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/controllers/order.dart';
import 'package:store_app/services/manage_http_response.dart';

class DeliveredOrderCountNotifier extends StateNotifier<int> {
  DeliveredOrderCountNotifier() : super(0);

  void fetchDeliveredOrderCount(String buyerId, context) async {
    try {
      final count = await OrderController().countDeliveredOrders(buyerId: buyerId);
      state = count;
    }
    catch (e) {
      showSnackBar(context, 'Error fetching delivered order count: $e');
    }
  }

  void resetDeliveredOrderCount() {
    state = 0;
  }
}

final deliveredOrderCountProvider = StateNotifierProvider<DeliveredOrderCountNotifier, int>((ref) {
  return DeliveredOrderCountNotifier();
});