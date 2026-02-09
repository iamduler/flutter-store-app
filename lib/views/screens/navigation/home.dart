import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';
import 'package:store_app/views/screens/navigation/widgets/banner.dart';
import 'package:store_app/views/screens/navigation/widgets/category_item.dart';
import 'package:store_app/views/screens/navigation/widgets/reusable_text.dart';
import 'package:store_app/views/screens/navigation/widgets/popular_product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            BannerWidget(),
            CategoryItemWidget(),
            ReusableTextWidget(title: 'Popular Products', subtitle: 'View all'),
            PopularProductWidget(),
          ],
        ),
      ),
    );
  }
}