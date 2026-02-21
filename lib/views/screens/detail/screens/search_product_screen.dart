import 'package:flutter/material.dart';
import 'package:store_app/controllers/product.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/views/screens/navigation/widgets/product_item.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductController _productController = ProductController();

  List<Product> _searchedProducts = [];
  bool _isLoading = false;

  void _searchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final keyword = _searchController.text.trim();

      if (keyword.isEmpty) {
        return;
      }

      final products = await _productController.searchProducts(keyword);
      setState(() {
        _searchedProducts = products;
      });
    } catch (e) {
      print('Error searching products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Set a number of columns based on the screen width
    final numColumns = screenWidth > 600 ? 4 : 2;

    // Set aspect ratio (height / width) based on the number of columns
    final aspectRatio = numColumns == 4 ? 4 / 5 : 2 / 3;
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Products',
            suffixIcon: IconButton(
              onPressed: () {
                _searchProducts();
              },
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          if (_isLoading)
            Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          else if (_searchedProducts.isEmpty)
            Center(child: Text('No products found'))
          else
            Expanded(
              child: GridView.builder(
                itemCount: _searchedProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numColumns,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final product = _searchedProducts[index];
                  return ProductItemWidget(product: product);
                },
              ),
            ),
        ],
      ),
    );
  }
}
