import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/vendor.dart';
import 'package:store_app/provider/vendor_product_provider.dart';
import 'package:store_app/controllers/product.dart';
import 'package:store_app/views/screens/navigation/widgets/product_item.dart';

class VendorProductScreen extends ConsumerStatefulWidget {
  final VendorModel vendor;
  const VendorProductScreen({super.key, required this.vendor});

  @override
  ConsumerState<VendorProductScreen> createState() =>
      _VendorProductScreenState();
}

class _VendorProductScreenState extends ConsumerState<VendorProductScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Defer product fetching to after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProductsIfNeeded();
    });
  }

  void _fetchProductsIfNeeded() {
    final products = ref.read(vendorProductProvider);

    // Check if vendor products are empty or if vendor has changed
    if (products.isEmpty || products.first.vendorId != widget.vendor.id) {
      ref.read(vendorProductProvider.notifier).setProducts([]);
      _fetchProducts();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ProductController().loadProductsByVendor(
        widget.vendor.id,
      );
      ref.read(vendorProductProvider.notifier).setProducts(products);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Set a number of columns based on the screen width
    final numColumns = screenWidth > 600 ? 4 : 2;

    // Set aspect ratio (height / width) based on the number of columns
    final aspectRatio = numColumns == 4 ? 4 / 5 : 2 / 3;
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
                            products.length.toString(),
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
                  '${widget.vendor.fullName} Products',
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              widget.vendor.image != null && widget.vendor.image!.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.vendor.image!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Text(
                        widget.vendor.fullName.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              Text(
                widget.vendor.fullName,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              widget.vendor.description != null &&
                      widget.vendor.description!.isNotEmpty
                  ? Text(
                      widget.vendor.description!,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : const SizedBox.shrink(),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 10),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : products.isEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numColumns,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductItemWidget(product: product);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
