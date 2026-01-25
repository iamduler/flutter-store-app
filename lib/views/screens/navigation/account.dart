import 'package:flutter/material.dart';
import 'package:store_app/controllers/auth.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () async {
        await _authController.signOut(context: context); // Sign out the user
      }, child: Text('Sign Out'))
    );
  }
}