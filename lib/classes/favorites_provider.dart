import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  List<int> favorites = [];
  FavoritesProvider({required this.favorites});

  void updateFavorites(int id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return favorites.contains(id);
  }
}
