import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/favorite.dart';

class FavoriteNotifier extends StateNotifier<Map<String, Favorite>> {
  FavoriteNotifier() : super({});

  void addToFavorites({
    required String productName,
    required int productPrice,
    required String category,
    required List<dynamic> images,
    required String vendorId,
    required String vendorName,
    required String productId,
  }) {
    state[productId] = Favorite(
      productName: productName,
      productPrice: productPrice,
      category: category,
      images: images.map((image) => image.toString()).toList(),
      vendorId: vendorId,
      vendorName: vendorName,
      productId: productId,
    );

    state = { ...state }; // Notify the listeners that the favorites have changed
  }

  void removeFromFavorites(String productId) {
    state.remove(productId);

    state = { ...state }; // Notify the listeners that the favorites have changed
  }

  Map<String, Favorite> get getFavorites => state;
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>((ref) {
  return FavoriteNotifier();
});