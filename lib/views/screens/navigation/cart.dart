import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/views/screens/navigation/widgets/product_image.dart';
import 'package:store_app/views/screens/detail/screens/checkout_screen.dart';
import 'package:store_app/views/screens/main.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = _cartProvider.calculateTotalAmount();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.20,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset('assets/icons/not.png', width: 25, height: 25),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            cartData.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  'My cart',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add products to your cart',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Shop now',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 49,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 49,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(color: Color(0xFFD7DDFF)),
                          ),
                        ),
                        Positioned(
                          left: 44,
                          top: 19,
                          child: Container(
                            width: 10,
                            height: 10,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 69,
                          top: 14,
                          child: Text(
                            'You have ${cartData.length} items in your cart',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartData.values.toList()[index];
                      final imageUrl = resolveProductImageUrl(cartItem.images);

                      return Card(
                        child: SizedBox(
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: ProductImageWidget(
                                  imageUrl: imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.productName,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    cartItem.category,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '\$${cartItem.productPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF102DE1),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _cartProvider.decrementQuantity(
                                                  productId: cartItem.productId,
                                                );
                                              },
                                              icon: Icon(
                                                CupertinoIcons.minus,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '${cartItem.quantity}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _cartProvider.incrementQuantity(
                                                  productId: cartItem.productId,
                                                );
                                              },
                                              icon: Icon(
                                                CupertinoIcons.plus,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      _cartProvider.removeFromCart(
                                        productId: cartItem.productId,
                                      );
                                    },
                                    icon: Icon(
                                      CupertinoIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        width: 416,
        height: 89,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 416,
                height: 89,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFC4C4C4)),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.64, -0.26),
              child: Text(
                'Subtotal',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA1A1A1),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.19, -0.31),
              child: Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6464),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.83, 0),
              child: InkWell(
                onTap: totalAmount > 0 ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutScreen(),
                    ),
                  );
                } : null,
                child: Container(
                  width: 166,
                  height: 71,
                  decoration: BoxDecoration(
                    color: totalAmount > 0 ? Color(0xFF1532F7) : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Checkout', style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
