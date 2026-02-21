import 'package:flutter/material.dart';
import 'package:store_app/models/subcategory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/provider/subcategory_product_provider.dart';
import 'package:store_app/controllers/product.dart';
import 'package:store_app/views/screens/navigation/widgets/product_item.dart';

class SubcategoryProductScreen extends ConsumerStatefulWidget {
  final SubcategoryModel subcategory;
  const SubcategoryProductScreen({super.key, required this.subcategory});

  @override
  ConsumerState<SubcategoryProductScreen> createState() =>
      _SubcategoryProductScreenState();
}

class _SubcategoryProductScreenState
    extends ConsumerState<SubcategoryProductScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Read the products from the provider
    final products = ref.read(subcategoryProductProvider);

    // If the products are empty, fetch them
    if (products.isEmpty) {
      _fetchProducts();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ProductController().loadProductsBySubcategory(
        widget.subcategory.subCategoryName,
      );
      ref.read(subcategoryProductProvider.notifier).setProducts(products);
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
    final products = ref.watch(subcategoryProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Set a number of columns based on the screen width
    final numColumns = screenWidth > 600 ? 4 : 2;

    // Set aspect ratio (height / width) based on the number of columns
    final aspectRatio = numColumns == 4 ? 4 / 5 : 2 / 3;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategory.subCategoryName)),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
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
    );
  }
}
