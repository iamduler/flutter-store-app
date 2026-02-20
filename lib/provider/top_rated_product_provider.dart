import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/product.dart';

class TopRatedProductNotifier extends StateNotifier<List<Product>> {
  TopRatedProductNotifier() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }
}

final topRatedProductProvider = StateNotifierProvider<TopRatedProductNotifier, List<Product>>((ref) {
  return TopRatedProductNotifier();
});