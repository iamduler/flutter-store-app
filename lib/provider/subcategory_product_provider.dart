import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/product.dart';

class SubcategoryProductNotifier extends StateNotifier<List<Product>> {
  SubcategoryProductNotifier() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }
}

final subcategoryProductProvider = StateNotifierProvider<SubcategoryProductNotifier, List<Product>>((ref) {
  return SubcategoryProductNotifier();
});