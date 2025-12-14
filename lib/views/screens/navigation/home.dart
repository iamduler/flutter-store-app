import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation/widgets/header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
          ],
        ),
      ),
    );
  }
}