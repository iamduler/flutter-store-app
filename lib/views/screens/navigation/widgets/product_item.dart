import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/product.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;
  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Safely resolve the image URL
    String? imageUrl;
    if (product.images.isNotEmpty && product.images[0] is String) {
      final candidate = product.images[0] as String;
      if (candidate.isNotEmpty) {
        imageUrl = candidate;
      }
    }

    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                // Display a placeholder image if the product has no valid image URL
                if (imageUrl == null || imageUrl.isEmpty)
                  Image.network(
                    'https://placehold.co/170x170/png?text=No+Image&font=roboto',
                    width: 170,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback UI if placeholder image also fails to load
                      return Container(
                        width: 170,
                        height: 170,
                        color: const Color(0xffF2F2F2),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  )
                // Display the first image of the product
                else
                  Image.network(
                    imageUrl,
                    width: 170,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback UI if product image fails to load
                      return Container(
                        width: 170,
                        height: 170,
                        color: const Color(0xffF2F2F2),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Image.asset(
                    'assets/icons/love.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Image.asset(
                    'assets/icons/cart.png',
                    width: 26,
                    height: 26,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          SizedBox(height: 8),
          Text(
            product.category,
            style: GoogleFonts.quicksand(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xff868D94),
            ),
          ),
        ],
      ),
    );
  }
}
