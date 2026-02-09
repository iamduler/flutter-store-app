import 'package:flutter/material.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/controllers/product.dart';
import 'package:store_app/views/screens/navigation/widgets/product_item.dart';

class PopularProductWidget extends StatefulWidget {
  const PopularProductWidget({super.key});

  @override
  State<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends State<PopularProductWidget> {
  late Future<List<Product>> futurePopularProducts;

  @override
  void initState() {
    super.initState();
    futurePopularProducts = ProductController().loadPopularProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futurePopularProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No popular products found'));
        } else {
          final products = snapshot.data!;

          return SizedBox(
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
      },
    );
  }
}
