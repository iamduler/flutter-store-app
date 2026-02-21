import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/provider/product_provider.dart';
import 'package:store_app/controllers/product.dart';
import 'package:store_app/views/screens/navigation/widgets/product_item.dart';

class PopularProductWidget extends ConsumerStatefulWidget {
  const PopularProductWidget({super.key});

  @override
  ConsumerState<PopularProductWidget> createState() =>
      _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<PopularProductWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Read the products from the provider
    final products = ref.read(productProvider);

    // If the products are empty, fetch them
    if (products.isEmpty) {
      _fetchProducts();
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ProductController().loadPopularProducts();
      ref.read(productProvider.notifier).setProducts(products);
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
    final products = ref.watch(productProvider);

    return isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
        : SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItemWidget(product: product);
              },
            ),
          );
  }
}
