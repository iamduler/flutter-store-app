import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/models/favorite.dart';

/// Top-level for [compute]; runs JSON decode off the main thread.
Map<String, Favorite> _decodeFavorites(String jsonString) {
  try {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) return {};
    return Map.fromEntries(
      decoded.entries
          .where((e) => e.value is Map<String, dynamic>)
          .map((e) => MapEntry(e.key, Favorite.fromJson(e.value as Map<String, dynamic>))),
    );
  } catch (_) {
    return {};
  }
}

/// Top-level for [compute]; runs JSON encode off the main thread.
String _encodeFavorites(Map<String, Map<String, dynamic>> encoded) {
  return jsonEncode(encoded);
}

class FavoriteNotifier extends StateNotifier<Map<String, Favorite>> {
  FavoriteNotifier() : super({}) {
    _loadFavoritesFromSharedPreferences();
  }

  Future<void> _loadFavoritesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = prefs.getString('favorites');
    if (favoriteString != null && favoriteString.isNotEmpty) {
      state = await compute(_decodeFavorites, favoriteString);
    }
  }

  Future<void> _saveFavoritesToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state.map((key, value) => MapEntry(key, value.toMap()));
    final jsonString = await compute(_encodeFavorites, encoded);
    await prefs.setString('favorites', jsonString);
  }

  void addToFavorites({
    required String productName,
    required int productPrice,
    required String category,
    required String image,
    required String vendorId,
    required String vendorName,
    required String productId,
  }) async {
    state[productId] = Favorite(
      productName: productName,
      productPrice: productPrice,
      category: category,
      image: image,
      vendorId: vendorId,
      vendorName: vendorName,
      productId: productId,
    );

    await _saveFavoritesToSharedPreferences();

    state = { ...state }; // Notify the listeners that the favorites have changed
  }

  void removeFromFavorites(String productId) async {
    state.remove(productId);

    await _saveFavoritesToSharedPreferences();

    state = { ...state }; // Notify the listeners that the favorites have changed
  }

  Map<String, Favorite> get getFavorites => state;
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>((ref) {
  return FavoriteNotifier();
});