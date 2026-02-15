import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/cart.dart';

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

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
  }) {
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
  }

  void incrementQuantity({
    required String productId,
  }) {
    // Check if the product is already in the cart
    if (state.containsKey(productId)) {
      // If the product is already in the cart, increment the quantity
      state[productId]!.quantity++;

      // Notify the listeners that the cart has changed
      state = { ...state };
    } 
  }

  void decrementQuantity({
    required String productId,
  }) {
    // Check if the product is already in the cart
    if (state.containsKey(productId)) {
      // If the product is already in the cart, decrement the quantity
      state[productId]!.quantity--;
    }

    // Notify the listeners that the cart has changed
    state = { ...state };
  }

  void removeFromCart({required String productId}) {
    state.remove(productId);

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
}

// Make the data accessible within the application
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});