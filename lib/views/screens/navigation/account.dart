import 'package:flutter/material.dart';
import 'package:store_app/controllers/auth.dart';
import 'package:store_app/views/screens/detail/screens/order_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  // final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // await _authController.signOut(context: context); // Sign out the user
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return OrderScreen();
              },
            ),
          );
        },
        child: Text('My Orders'),
      ),
    );
  }
}
