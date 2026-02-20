import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/favorite_provider.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/detail/screens/product_detail_screen.dart';
import 'package:store_app/views/screens/navigation/widgets/product_image.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final Product product;
  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = resolveProductImageUrl(widget.product.images);

    // Favorite
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);

    final isInFavorite = favoriteProviderData.getFavorites.containsKey(
      widget.product.id,
    );

    // Cart
    final cartProviderData = ref.read(cartProvider.notifier);
    ref.watch(cartProvider);
    final isInCart = cartProviderData.getCartItems.containsKey(
      widget.product.id,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product),
          ),
        );
      },
      child: Container(
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProductImageWidget(
                      imageUrl: imageUrl,
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: InkWell(
                      onTap: () {
                        if (isInFavorite) {
                          favoriteProviderData.removeFromFavorites(
                            widget.product.id,
                          );
                          showSnackBar(
                            context,
                            'Product removed from favorites',
                          );
                        } else {
                          favoriteProviderData.addToFavorites(
                            productName: widget.product.name,
                            productPrice: widget.product.price,
                            category: widget.product.category,
                            images: widget.product.images,
                            vendorId: widget.product.vendorId,
                            vendorName: widget.product.vendorName,
                            productId: widget.product.id,
                          );
                          showSnackBar(context, 'Product added to favorites');
                        }
                      },
                      child: isInFavorite
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: InkWell(
                      onTap: () {
                        if (isInCart) {
                          print('Product is in cart');
                        } else {
                                cartProviderData.addToCart(
                                  productName: widget.product.name,
                                  productPrice: widget.product.price,
                                  category: widget.product.category,
                                  images: widget.product.images
                                      .map((image) => image.toString())
                                      .toList(),
                                  vendorId: widget.product.vendorId,
                                  vendorName: widget.product.vendorName,
                                  productQuantity: widget.product.quantity,
                                  quantity: 1,
                                  productId: widget.product.id,
                                  description: widget.product.description ?? '',
                                );

                                // Show a success message
                            showSnackBar(context, 'Product added to cart');
                          }
                      },
                      child: Image.asset(
                        'assets/icons/cart.png',
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF212121),
              ),
            ),
            widget.product.averageRating == 0
                ? SizedBox()
                : Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${widget.product.averageRating.toStringAsFixed(1)} (${widget.product.totalRatings})',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
            Text(
              widget.product.category,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xff868D94),
              ),
            ),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
