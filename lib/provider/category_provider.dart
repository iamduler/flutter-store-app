import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/category.dart';

class CategoryProvider extends StateNotifier<List<CategoryModel>> {
  CategoryProvider() : super([]);

  void setCategories(List<CategoryModel> categories) {
    state = categories;
  }
}

final categoryProvider = StateNotifierProvider<CategoryProvider, List<CategoryModel>>((ref) {
  return CategoryProvider();
});