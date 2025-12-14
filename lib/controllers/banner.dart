import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_app/global_variable.dart';
import 'package:store_app/models/banner.dart';

class BannerController {
  
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/banners'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners = data
            .map((banner) => BannerModel.fromJson(banner))
            .toList();
        return banners;
      }

      // If the response is not 200, return an empty list
      throw Exception('Failed to load banners');
    } catch (e) {
      throw Exception('Error loading banners: $e');
    }
  }
}
