import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/subcategory.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';
import 'package:store_app/controllers/category.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/controllers/subcategory.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // A list of categories
  late Future<List<CategoryModel>> futureCategories;
  CategoryModel? _selectedCategory;
  List<SubcategoryModel>? _subcategories = [];

  final SubcategoryController _subcategoryController = SubcategoryController();

  // Load subcategories for the selected category
  Future<void> _loadSubcategories(String categoryName) async {
    final subcategories = await _subcategoryController
        .getSubcategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();

    // Set default category to Fashion
    futureCategories.then((categories) {
      for (var category in categories) {
        if (category.name == 'Fashion') {
          setState(() {
            _selectedCategory = category;
          });
          _loadSubcategories(category.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: HeaderWidget(),
      ),
      body: Row(
        children: [
          // Left side display categories
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final categories = snapshot.data!;
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListTile(
                          onTap: () => setState(() {
                            _selectedCategory = category;
                            _loadSubcategories(category.name);
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
                    );
                  } else {
                    return Center(child: Text('No categories found'));
                  }
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
                  ? Column(
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
                                image: NetworkImage(_selectedCategory!.banner),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        _subcategories!.isNotEmpty
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: _subcategories!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 8,
                                    ),
                                itemBuilder: (context, index) {
                                  final subcategory = _subcategories![index];
                                  return Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            subcategory.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          subcategory.subCategoryName,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
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
                    )
                  : Center(child: Text('Select a category')),
            ),
          ),
        ],
      ),
    );
  }
}
