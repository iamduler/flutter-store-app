import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/product.dart';

class VendorProductProvider extends StateNotifier<List<Product>> {
  VendorProductProvider() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }
}

final vendorProductProvider = StateNotifierProvider<VendorProductProvider, List<Product>>((ref) {
  return VendorProductProvider();
});