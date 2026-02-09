import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_app/models/product.dart';
import 'package:store_app/global_variable.dart';

class ProductController {

  Future<List<Product>> loadPopularProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/popular'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> products = data.map((product) => Product.fromJson(product)).toList();
        return products;
      }
      throw Exception('Failed to load popular products');
    } catch (e) {
      throw Exception('Error loading popular products: $e');
    }
  }
}
