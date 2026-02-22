import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/models/vendor.dart';
import 'package:store_app/global_variable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
final providerContainer = ProviderContainer();

class VendorAuthController {

  Future<List<VendorModel>> loadVendors() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendor'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<VendorModel> vendors = data
            .map((vendor) => VendorModel.fromJson(vendor))
            .toList();
        return vendors;
      }
      else if (response.statusCode == 404) {
        return [];
      }

      // If the response is not 200, return an empty list
      throw Exception('Failed to load vendors');
    } catch (e) {
      throw Exception('Error loading vendors: $e');
    }
  }
}
