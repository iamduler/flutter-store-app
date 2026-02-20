import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';
import 'package:store_app/views/screens/navigation/widgets/banner.dart';
import 'package:store_app/views/screens/navigation/widgets/category_item.dart';
import 'package:store_app/views/screens/navigation/widgets/reusable_text.dart';
import 'package:store_app/views/screens/navigation/widgets/popular_product.dart';
import 'package:store_app/views/screens/navigation/widgets/top_rated_product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.2,
        ),
        child: const HeaderWidget(),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            BannerWidget(),
            CategoryItemWidget(),
            ReusableTextWidget(title: 'Popular Products', subtitle: ''),
            PopularProductWidget(),
            ReusableTextWidget(title: 'Top Rated Products', subtitle: ''),
            TopRatedProductWidget(),
          ],
        ),
      ),
    );
  }
}
