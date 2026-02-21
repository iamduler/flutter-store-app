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
      else if (response.statusCode == 404) {
        return [];
      }
      
      throw Exception('Failed to load popular products');
    } catch (e) {
      throw Exception('Error loading popular products: $e');
    }
  }
  
  Future<List<Product>> loadProductsByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/category/$category'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> products = data.map((product) => Product.fromJson(product)).toList();
        return products;
      }
      else if (response.statusCode == 404) {
        return [];
      }

      throw Exception('Failed to load products by category');
    } catch (e) {
      throw Exception('Error loading products by category: $e');
    }
  }

  // Get related products by subcategory
  Future<List<Product>> loadRelatedProductsBySubcategory(String productId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/$productId/related'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> products = data.map((product) => Product.fromJson(product)).toList();
        return products;
      }
      else if (response.statusCode == 404) {
        return [];
      }

      throw Exception('Failed to load related products by subcategory');
    } catch (e) {
      throw Exception('Error loading related products by subcategory: $e');
    }
  }

  // Get the top 10 products by rating
  Future<List<Product>> loadTop10ProductsByRating() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/top-rated'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> products = data.map((product) => Product.fromJson(product)).toList();
        return products;
      }
      else if (response.statusCode == 404) {
        return [];
      }

      throw Exception('Failed to load top 10 products by rating');
    } catch (e) {
      throw Exception('Error loading top 10 products by rating: $e');
    }
  }
}
