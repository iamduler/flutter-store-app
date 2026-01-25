import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/global_variable.dart';
import 'package:store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/authentication/login.dart';
import 'package:store_app/views/screens/main.dart';
import 'package:store_app/provider/user_provider.dart';

final providerContainer = ProviderContainer();

class AuthController {
  Future<void> signUp({
    required context,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        address: '',
        gender: '',
        password: password,
        token: '',
      );

      final http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login screen
          );
          showSnackBar(context, 'Account created successfully');
        },
      );
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  Future<void> signIn({
    required context,
    required String email,
    required String password,
  }) async {
    final http.Response response = await http.post(
      Uri.parse('$uri/api/signin'),
      body: json.encode({'email': email, 'password': password}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    manageHttpResponse(
      response: response,
      context: context,
      onSuccess: () async {
        // Access shared preferences to store the user token
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Get the token from the response body
        String token = jsonDecode(response.body)['token'];
        
        // Store the authentication token securely in shared preferences
        await prefs.setString('auth_token', token);

        // Encode the user data to JSON
        final userJson = jsonEncode(jsonDecode(response.body)['user']);

        // Update the application state with the user data using Riverpod
        providerContainer.read(userProvider.notifier).setUser(userJson);

        // Store the data in shared preferences for future use
        await prefs.setString('user', userJson);

        // Navigate to main screen and remove all previous screens from the stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false, // Navigate to main screen
        );
        showSnackBar(context, 'Login successful');
      },
    );
  }

  Future<void> signOut({ required context }) async {
    try {
      // Access shared preferences to clear the user token
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear the authentication token and user data from shared preferences
      await prefs.remove('auth_token');
      await prefs.remove('user');

      // Clear the user data from the application state using Riverpod
      providerContainer.read(userProvider.notifier).signOut();

      // Navigate the user to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false, // Navigate to login screen
      );
      showSnackBar(context, 'Logout successful');
    }
    catch (e) {
      showSnackBar(context, 'Error signing out: $e');
      print('Error signing out: $e');
    }
  }
}
