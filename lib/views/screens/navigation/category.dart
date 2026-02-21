import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/subcategory.dart';
import 'package:store_app/views/screens/detail/screens/subcategory_product_screen.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';
import 'package:store_app/controllers/category.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/controllers/subcategory.dart';
import 'package:store_app/views/screens/detail/screens/widgets/subcategory_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/provider/category_provider.dart';
import 'package:store_app/provider/subcategory_provider.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final bool includeHeader;
  const CategoryScreen({super.key, bool? includeHeader})
    : includeHeader = includeHeader ?? true;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    try {
      final categories = await CategoryController().loadCategories();
      ref.read(categoryProvider.notifier).setCategories(categories);

      // Set the default category to Fashion
      for (var category in categories) {
        if (category.name == 'Fashion') {
          setState(() {
            _selectedCategory = category;
          });

          // Load the subcategories
          _fetchSubcategories(category.name);
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }

    return [];
  }

  Future<List<SubcategoryModel>> _fetchSubcategories(
    String categoryName,
  ) async {
    try {
      final subcategories = await SubcategoryController()
          .getSubcategoriesByCategoryName(categoryName);
      ref.read(subcategoryProvider.notifier).setSubcategories(subcategories);

      return subcategories;
    } catch (e) {
      print('Error fetching subcategories: $e');
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final subcategories = ref.watch(subcategoryProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: widget.includeHeader
            ? Size.fromHeight(MediaQuery.of(context).size.height * 0.12)
            : Size.fromHeight(0),
        child: widget.includeHeader
            ? const HeaderWidget()
            : const SizedBox.shrink(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side display categories
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    onTap: () => setState(() {
                      _selectedCategory = category;
                      _fetchSubcategories(category.name);
                    }),
                    selected: _selectedCategory == category,
                    title: Text(
                      category.name,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _selectedCategory == category
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Right side display selected category details
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: _selectedCategory != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _selectedCategory!.name,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    _selectedCategory!.banner,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          subcategories.isNotEmpty
                              ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: subcategories.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 2 / 3,
                                      ),
                                  itemBuilder: (context, index) {
                                    final subcategory = subcategories[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SubcategoryProductScreen(subcategory: subcategory),
                                          ),
                                        );
                                      },
                                      child: SubcategoryTileWidget(
                                        image: subcategory.image,
                                        title: subcategory.subCategoryName,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No subcategories found',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  : Center(child: Text('Select a category')),
            ),
          ),
        ],
      ),
    );
  }
}
