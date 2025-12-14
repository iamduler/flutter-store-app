import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';
import 'package:store_app/views/screens/navigation/widgets/banner.dart';
import 'package:store_app/views/screens/navigation/widgets/category_item.dart';

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
          ],
        ),
      ),
    );
  }
}