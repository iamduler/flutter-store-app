import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/product.dart';

class RelatedProductNotifier extends StateNotifier<List<Product>> {
  RelatedProductNotifier() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }
}

final relatedProductProvider = StateNotifierProvider<RelatedProductNotifier, List<Product>>((ref) {
  return RelatedProductNotifier();
});