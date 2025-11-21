import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({required http.Response response, required BuildContext context, required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 400:
    case 401:
    case 404:
      showSnackBar(context, json.decode(response.body)['message']);
      break;
    case 500:
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    default:
      showSnackBar(context, 'Failed to load data');
      break;
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}