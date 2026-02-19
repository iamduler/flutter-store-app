import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/user_provider.dart';
import 'package:store_app/controllers/order.dart';
import 'package:store_app/provider/order_provider.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/detail/screens/order_detail_screen.dart';
import 'package:store_app/views/screens/navigation/widgets/product_image.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final user = ref.read(userProvider);

    if (user != null) {
      try {
        print('Fetching orders for user: ${user.id}');
        final orders = await OrderController().loadOrders(buyerId: user.id);
        ref.read(orderProvider.notifier).setOrders(orders);
      } catch (e) {
        print('Error fetching orders: ${e}');
      }
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      await OrderController().deleteOrder(orderId: orderId, context: context);
      _fetchOrders(); // Refresh the orders list
    } catch (e) {
      print('Error deleting order: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
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
                            orders.length.toString(),
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
                  'My orders',
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
      body: orders.isEmpty
          ? const Center(child: Text('No orders found'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final imageUrl = resolveProductImageUrlAt([order.image], 0);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    child: Container(
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
                                  border: Border.all(
                                    color: const Color(0xFFEFF0F2),
                                  ),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        order.productName,
                                                        style:
                                                            GoogleFonts.roboto(
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          order.category,
                                                          style:
                                                              GoogleFonts.roboto(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    const Color(
                                                                      0xFF8F9091,
                                                                    ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '\$${order.price.toStringAsFixed(2)}',
                                                        style:
                                                            GoogleFonts.roboto(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.pink,
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
                                          color: order.delivered == true
                                              ? Colors.green
                                              : order.processing == true
                                              ? Colors.purple
                                              : Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 9,
                                              top: 2,
                                              child: Text(
                                                order.delivered == true
                                                    ? 'Delivered'
                                                    : order.processing == true
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
                                          _deleteOrder(order.id);
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
                  ),
                );
              },
            ),
    );
  }
}
