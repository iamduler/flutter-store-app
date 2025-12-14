import 'dart:convert';

import 'package:store_app/global_variable.dart';
import 'package:store_app/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
 
  Future<List<SubcategoryModel>> getSubcategoriesByCategoryName(String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories/$categoryName/subcategories'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final List<SubcategoryModel> subcategories = data.map((subcategory) => SubcategoryModel.fromJson(subcategory)).toList();
          return subcategories;
        }

        print('No subcategories found');
        return [];
      }
      else if (response.statusCode == 404) {
        print('Subcategories not found');
        return [];
      }
      else {
        print('Failed to load subcategories');
        return [];
      }
    } catch (e) {
      print('Error loading subcategories: $e');
      return [];
    }
  }
}
