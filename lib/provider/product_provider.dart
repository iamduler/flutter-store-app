import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/product.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});