import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/controllers/order.dart';
import 'package:store_app/views/screens/navigation/widgets/product_image.dart';
import 'package:store_app/provider/user_provider.dart';
import 'package:store_app/views/screens/detail/screens/shipping_address_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'stripe';

  @override
  Widget build(BuildContext context) {
    final cartData = ref.read(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final user = ref.watch(userProvider);
    final OrderController orderController = OrderController();

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShippingAddressScreen(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 335,
                  height: 74,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 335,
                          height: 74,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEFF0F2)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 70,
                        top: 17,
                        child: SizedBox(
                          width: 215,
                          height: 41,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: -1,
                                top: -1,
                                child: SizedBox(
                                  width: 219,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 114,
                                          child: user!.state.isEmpty
                                              ? Text(
                                                  'Add address',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.1,
                                                  ),
                                                )
                                              : Text(
                                                  'Address',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.1,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${user.state}, ${user.city}, ${user.locality}',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
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
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFBF7F5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Image.network(
                                          width: 26,
                                          height: 26,
                                          'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png',
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
                        left: 305,
                        top: 25,
                        child: Image.network(
                          width: 20,
                          height: 20,
                          'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6ce18a0efc6e889de2f2878027c689c9caa53feeedit%201.png?alt=media&token=a3a8a999-80d5-4a2e-a9b7-a43a7fa8789a',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your Items',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: cartData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final cartItem = cartData.values.toList()[index];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        width: 336,
                        height: 91,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFEFF0F2)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 6,
                              top: 6,
                              child: SizedBox(
                                width: 311,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 78,
                                      height: 78,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFBCF5FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ProductImageWidget(
                                        imageUrl: resolveProductImageUrl(
                                          cartItem.images,
                                        ),
                                        width: 78,
                                        height: 78,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: Container(
                                        height: 78,
                                        alignment: const Alignment(0, -0.51),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  cartItem.productName,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  cartItem.category,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '\$${cartItem.productPrice.toStringAsFixed(2)}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Choose Payment Method',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              RadioListTile<String>(
                title: Text(
                  'Stripe',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                activeColor: Colors.pink,
                value: 'stripe',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Cash on Delivery',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                activeColor: Colors.pink,
                value: 'cash_on_delivery',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: user.state.isEmpty
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShippingAddressScreen(),
                    ),
                  );
                },
                child: Text(
                  'Please enter your address',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              )
            : InkWell(
                onTap: () async {
                  if (selectedPaymentMethod == 'cash_on_delivery') {
                    await Future.forEach(_cartProvider.getCartItems.entries, (
                      entry,
                    ) {
                      var item = entry.value;
                      var address =
                          '${user.state}, ${user.city}, ${user.locality}';
                      orderController.uploadOrder(
                        id: '',
                        fullName: user.fullName,
                        email: user.email,
                        address: address,
                        phone: '',
                        productName: item.productName,
                        price: item.productPrice,
                        quantity: item.productQuantity,
                        category: item.category,
                        image: resolveProductImageUrl(item.images)!,
                        buyerId: user.id,
                        vendorId: item.vendorId,
                        processing: true,
                        delivered: false,
                        context: context,
                      );
                    });
                  } else if (selectedPaymentMethod == 'stripe') {
                    // Implement Stripe payment
                  } else {
                    showSnackBar(context, 'Please select a payment method');
                  }
                },
                child: Container(
                  width: 338,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3854EE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      selectedPaymentMethod == 'cash_on_delivery'
                          ? 'Pay with COD'
                          : 'Pay Now',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
