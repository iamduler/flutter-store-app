import 'package:flutter/material.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/views/screens/detail/screens/widgets/inner_category_content.dart';
import 'package:store_app/views/screens/navigation/favorite.dart';
import 'package:store_app/views/screens/navigation/category.dart';
import 'package:store_app/views/screens/navigation/store.dart';
import 'package:store_app/views/screens/navigation/cart.dart';
import 'package:store_app/views/screens/navigation/account.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryModel category;
  const InnerCategoryScreen({super.key, required this.category});
  final int subcategoriesPerRow = 7;

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InnerCategoryContentWidget(category: widget.category),
      FavoriteScreen(),
      CategoryScreen(includeHeader: false),
      StoreScreen(),
      CartScreen(),
      AccountScreen(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: HeaderWidget(includeBackButton: true),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/love.png', width: 25),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/mart.png', width: 25),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/cart.png', width: 25),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/user.png', width: 25),
            label: 'Account',
          ),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}
