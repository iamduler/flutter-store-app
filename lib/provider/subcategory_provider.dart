import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/subcategory.dart';

class SubcategoryNotifier extends StateNotifier<List<SubcategoryModel>> {
  SubcategoryNotifier() : super([]);

  void setSubcategories(List<SubcategoryModel> subcategories) {
    state = subcategories;
  }
}

final subcategoryProvider = StateNotifierProvider<SubcategoryNotifier, List<SubcategoryModel>>((ref) {
  return SubcategoryNotifier();
});