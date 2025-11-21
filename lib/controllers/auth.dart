import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/global_variable.dart';
import 'package:store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/authentication/login.dart';
import 'package:store_app/views/screens/main.dart';

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
      onSuccess: () {
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
}
