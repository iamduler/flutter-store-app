import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/provider/top_rated_product_provider.dart';
import 'package:store_app/controllers/product.dart';
import 'package:store_app/views/screens/navigation/widgets/product_item.dart';

class TopRatedProductWidget extends ConsumerStatefulWidget {
  const TopRatedProductWidget({super.key});

  @override
  ConsumerState<TopRatedProductWidget> createState() =>
      _TopRatedProductWidgetState();
}

class _TopRatedProductWidgetState extends ConsumerState<TopRatedProductWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Read the products from the provider
    final products = ref.read(topRatedProductProvider);

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
      final products = await ProductController().loadTop10ProductsByRating();
      ref.read(topRatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      print('Error fetching top 10 products by rating: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(topRatedProductProvider);

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
