import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/cart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


/// Top-level for [compute]; runs JSON decode off the main thread.
Map<String, Cart> _decodeCarts(String jsonString) {
  try {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) return {};
    return Map.fromEntries(
      decoded.entries
          .where((e) => e.value is Map<String, dynamic>)
          .map((e) => MapEntry(e.key, Cart.fromJson(e.value as Map<String, dynamic>))),
    );
  } catch (e) {
    return {};
  }
}

/// Top-level for [compute]; runs JSON encode off the main thread.
String _encodeCarts(Map<String, Map<String, dynamic>> encoded) {
  return jsonEncode(encoded);
}
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCartsFromSharedPreferences();
  }

  Future<void> _loadCartsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('carts');
    print('cartString: $cartString');
    if (cartString != null && cartString.isNotEmpty) {
      state = await compute(_decodeCarts, cartString);
      print('state: ${state}');
    }
  }

  Future<void> _saveCartsToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state.map((key, value) => MapEntry(key, value.toMap()));
    final jsonString = await compute(_encodeCarts, encoded);
    print('jsonString: $jsonString');
    await prefs.setString('carts', jsonString);
  }

  void addToCart({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> images,
    required String vendorId,
    required String vendorName,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
  }) async {
    // Check if the product is already in the cart
    if (state.containsKey(productId)) {
      // If the product is already in the cart, increment the quantity
      state = {
        ...state,
        productId: Cart(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          images: state[productId]!.images,
          vendorId: state[productId]!.vendorId,
          vendorName: state[productId]!.vendorName,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
        ),
      };
    } else {
      // If the product is not in the cart, add it to the cart
      state = {
        ...state,
        productId: Cart(
          productName: productName,
          productPrice: productPrice,
          category: category,
          images: images,
          vendorId: vendorId,
          vendorName: vendorName,
          productQuantity: productQuantity,
          quantity: quantity,
          productId: productId,
          description: description,
        ),
      };
    }

    await _saveCartsToSharedPreferences();
  }

  void incrementQuantity({
    required String productId,
  }) async {
    // Check if the product is already in the cart
    if (state.containsKey(productId)) {
      // If the product is already in the cart, increment the quantity
      state[productId]!.quantity++;

      await _saveCartsToSharedPreferences();

      // Notify the listeners that the cart has changed
      state = { ...state };
    } 
  }

  void decrementQuantity({
    required String productId,
  }) async {
    // Check if the product is already in the cart
    if (state.containsKey(productId)) {
      // If the product is already in the cart, decrement the quantity
      state[productId]!.quantity--;
    }

    await _saveCartsToSharedPreferences();

    // Notify the listeners that the cart has changed
    state = { ...state };
  }

  void removeFromCart({required String productId}) async {
    state.remove(productId);

    await _saveCartsToSharedPreferences();

    // Notify the listeners that the cart has changed
    state = { ...state };
  }

  // Calculate the total amount of the cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;

    state.forEach((productId, cart) {
      totalAmount += cart.productPrice * cart.quantity;
    });

    return totalAmount;
  }

  Map<String, Cart> get getCartItems => state;
}

// Make the data accessible within the application
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});