import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:store_app/controllers/order.dart';
import 'package:store_app/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/views/screens/navigation/widgets/product_image.dart';
import 'package:store_app/controllers/product_review.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();

  final ProductReviewController _productReviewController =
      ProductReviewController();

  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final imageUrl = resolveProductImageUrlAt([widget.order.image], 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order.productName,
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 335,
            height: 153,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 336,
                      height: 154,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFEFF0F2)),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 13,
                            top: 9,
                            child: Container(
                              width: 78,
                              height: 78,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBCC5FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 10,
                                    top: 5,
                                    child: Image.network(
                                      imageUrl!,
                                      width: 58,
                                      height: 67,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 101,
                            top: 14,
                            child: SizedBox(
                              width: 216,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.order.productName,
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                widget.order.category,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(
                                                    0xFF8F9091,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '\$${widget.order.price.toStringAsFixed(2)}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 113,
                            child: Container(
                              width: 80,
                              height: 22,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: widget.order.delivered == true
                                    ? Colors.green
                                    : widget.order.processing == true
                                    ? Colors.purple
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 2,
                                    child: Text(
                                      widget.order.delivered == true
                                          ? 'Delivered'
                                          : widget.order.processing == true
                                          ? 'Processing'
                                          : 'Cancelled',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 115,
                            left: 298,
                            child: InkWell(
                              onTap: () {
                                OrderController().deleteOrder(
                                  orderId: widget.order.id,
                                  context: context,
                                );
                              },
                              child: Image.asset(
                                'assets/icons/delete.png',
                                width: 16,
                                height: 16,
                                fit: BoxFit.contain,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: 336,
              height: widget.order.delivered == true ? 170 : 120,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFEFF0F2)),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Address',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.order.locality}, ${widget.order.city}, ${widget.order.state}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'To: ${widget.order.fullName}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Order ID: ${widget.order.id}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  widget.order.delivered == true
                      ? TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Leave a review'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _reviewController,
                                        decoration: InputDecoration(
                                          labelText: 'Your review',
                                        ),
                                      ),
                                      RatingBar(
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        onRatingChanged: (value) {
                                          rating = value;
                                        },
                                        initialRating: 3,
                                        maxRating: 5,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        final review = _reviewController.text;

                                        _productReviewController.uploadReview(
                                          buyerId: widget.order.buyerId,
                                          email: widget.order.email,
                                          fullName: widget.order.fullName,
                                          productId: widget.order.id,
                                          rating: rating,
                                          review: review,
                                          context: context,
                                        ).whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Leave a review',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
