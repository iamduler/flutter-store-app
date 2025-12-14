import 'package:flutter/material.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/views/screens/detail/screens/widgets/inner_banner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/subcategory.dart';
import 'package:store_app/controllers/subcategory.dart';
import 'package:store_app/views/screens/detail/screens/widgets/subcategory_tile.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final CategoryModel category;
  const InnerCategoryContentWidget({super.key, required this.category});
  final int subcategoriesPerRow = 7;

  @override
  State<InnerCategoryContentWidget> createState() => _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState extends State<InnerCategoryContentWidget> {
  late Future<List<SubcategoryModel>> _futureSubcategories;
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    super.initState();
    _futureSubcategories = _subcategoryController
        .getSubcategoriesByCategoryName(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Shop by Category: ${widget.category.name}',
                  style: GoogleFonts.quicksand(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _futureSubcategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No subcategories found'));
                } else {
                  final subcategories = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate((subcategories.length / widget.subcategoriesPerRow).ceil(), (
                        index,
                      ) {
                        // For each row, calculate the start and end index of the subcategories
                        final startIndex = index * widget.subcategoriesPerRow;
                        final endIndex = (index + 1) * widget.subcategoriesPerRow;
        
                        // Create a padding widget to add space between the rows
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: subcategories
                                .sublist(startIndex, endIndex > subcategories.length ? subcategories.length : endIndex)
                                .map(
                                  (subcategory) => SubcategoryTileWidget(
                                    image: subcategory.image,
                                    title: subcategory.subCategoryName,
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
