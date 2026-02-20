import 'package:http/http.dart' as http;
import 'package:store_app/models/product_review.dart';
import 'package:store_app/global_variable.dart';
import 'package:store_app/services/manage_http_response.dart';

class ProductReviewController {

  uploadReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context,
  }) async {
    try {
      final ProductReview productReview = ProductReview(
        id: '',
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        productId: productId,
        rating: rating,
        review: review,
      );

      final http.Response response = await http.post(
        Uri.parse('$uri/api/product-reviews'),
        body: productReview.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Review uploaded successfully');
        },
      );
    }
    catch (e) {
      throw Exception('Error uploading review: $e');
    }
  }
}