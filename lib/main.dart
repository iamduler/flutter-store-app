import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:store_app/views/screens/authentication/login.dart';
import 'package:store_app/views/screens/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Không gọi Stripe ở đây: plugin native chưa sẵn sàng lúc startup trên Android
  // → gây MissingPluginException. Khởi tạo Stripe khi user thanh toán (màn checkout).

  runApp(ProviderScope(child: const MyApp()));
}

// Root the widget of the application, a consumerWidget to consume the state change
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Method to check the token and set the user data if available
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // Obtain an instance of the shared preferences for local data storage
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the token from the shared preferences
    String? token = prefs.getString('auth_token');
    String? userJson = prefs.getString('user');

    // If both the token and user data are not empty, set the user data
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    }
    else {
      // If either the token or user data is empty, sign out the user
      ref.read(userProvider.notifier).signOut();
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Set the system UI overlay style to transparent status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(future: _checkTokenAndSetUser(ref), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = ref.watch(userProvider);
        return user != null ? MainScreen() : LoginScreen();
      }),
    );
  }
}