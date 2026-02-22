import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/global_variable.dart';
import 'package:store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/authentication/login.dart';
import 'package:store_app/views/screens/authentication/otp.dart';
import 'package:store_app/views/screens/main.dart';
import 'package:store_app/provider/user_provider.dart';
import 'package:store_app/provider/delivered_order_provider.dart';

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
        state: '',
        city: '',
        locality: '',
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
            MaterialPageRoute(
              builder: (context) => OTPScreen(email: email),
            ), // Navigate to login screen
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
    required WidgetRef ref,
  }) async {
    try {
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
          final Map<String, dynamic> decodedBody =
              jsonDecode(response.body) as Map<String, dynamic>;
          final String token = decodedBody['token'] as String;

          // Store the authentication token securely in shared preferences
          await prefs.setString('auth_token', token);

          // Use the entire response body as the user JSON,
          // because the API returns the user fields at the top level
          final String userJson = response.body;

          // Update the application state with the user data using Riverpod
          ref.read(userProvider.notifier).setUser(userJson);

          // Store the data in shared preferences for future use
          await prefs.setString('user', userJson);

          // Navigate to main screen and remove all previous screens from the stack
          if (ref.read(userProvider)!.token.isNotEmpty) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false, // Navigate to main screen
            );
            showSnackBar(context, 'Login successful');
          }
          else {
            showSnackBar(context, 'Invalid token');
          }
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error signing in: $e');
    }
  }

  Future<void> signOut({required context, required WidgetRef ref}) async {
    try {
      // Access shared preferences to clear the user token
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear the authentication token and user data from shared preferences
      await prefs.remove('auth_token');
      await prefs.remove('user');

      // Clear the user data from the application state using Riverpod
      ref.read(userProvider.notifier).signOut();

      // Clear the delivered order count from the application state using Riverpod
      ref.read(deliveredOrderCountProvider.notifier).resetDeliveredOrderCount();

      // Navigate the user to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false, // Navigate to login screen
      );
      showSnackBar(context, 'Logout successful');
    } catch (e) {
      showSnackBar(context, 'Error signing out: $e');
      print('Error signing out: $e');
    }
  }

  Future<void> saveAddress({
    required context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        body: json.encode({'state': state, 'city': city, 'locality': locality}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final userJson = jsonDecode(response.body);
          final userString = jsonEncode(userJson);

          // Update the user data in the application state using Riverpod
          ref.read(userProvider.notifier).setUser(userString);

          // Store the user data in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', userString);
        },
      );
    } catch (e) {
      print('Error saving address: $e');
    }
  }

  Future<void> verifyOTP({
    required context,
    required String email,
    required String otp,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$uri/api/verify-otp'),
        body: json.encode({'email': email, 'otp': otp}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );

          showSnackBar(context, 'Account verified. Please login to continue');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error verifying OTP: $e');
    }
  }

  Future<void> deleteUser({
    required context,
    required String id,
    required WidgetRef ref, // Access the riverpod state
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        showSnackBar(context, 'Please login to continue');
        return;
      }

      final http.Response response = await http.delete(
        Uri.parse('$uri/api/users/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token,
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          // Clear the user data from the application state using Riverpod
          ref.read(userProvider.notifier).signOut();

          // Clear the user data from shared preferences
          await prefs.remove('user');
          await prefs.remove('auth_token');

          // Navigate to login screen and remove all previous screens from the stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
          showSnackBar(context, 'User deleted successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error deleting user: $e');
    }
  }

  getUser({required context, required WidgetRef ref}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        showSnackBar(context, 'Please login to continue');
        return;
      }

      final http.Response tokenResponse = await http.get(
        Uri.parse('$uri/api/check-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token,
        },
      );

      var isValidToken = jsonDecode(tokenResponse.body);

      if (isValidToken == true) {
        // Fetch the user data
        final http.Response userResponse = await http.get(
          Uri.parse('$uri/api/users/me'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
            'x-auth-token': token,
          },
        );

        ref.read(userProvider.notifier).setUser(userResponse.body);
      }
      else {
        showSnackBar(context, 'Invalid token');
      }
    } catch (e) {
      showSnackBar(context, 'Error getting user: $e');
    }
  }
}
