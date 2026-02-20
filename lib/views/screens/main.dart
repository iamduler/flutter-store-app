import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation/home.dart';
import 'package:store_app/views/screens/navigation/favorite.dart';
import 'package:store_app/views/screens/navigation/store.dart';
import 'package:store_app/views/screens/navigation/cart.dart';
import 'package:store_app/views/screens/navigation/account.dart';
import 'package:store_app/views/screens/navigation/category.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return FavoriteScreen();
      case 2:
        return CategoryScreen();
      case 3:
        return StoreScreen();
      case 4:
        return CartScreen();
      case 5:
        return AccountScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
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
      body: _buildPage(_pageIndex),
    );
  }
}
