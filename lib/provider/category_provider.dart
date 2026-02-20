import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/category.dart';

class CategoryNotifier extends StateNotifier<List<CategoryModel>> {
  CategoryNotifier() : super([]);

  void setCategories(List<CategoryModel> categories) {
    state = categories;
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<CategoryModel>>((ref) {
  return CategoryNotifier();
});