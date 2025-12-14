import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_app/models/category.dart';
import 'package:store_app/global_variable.dart';

class CategoryController {

  Future<List<CategoryModel>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<CategoryModel> categories = data.map((category) => CategoryModel.fromJson(category)).toList();
        return categories;
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }
}
