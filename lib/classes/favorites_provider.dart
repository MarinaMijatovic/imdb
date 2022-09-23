import 'package:flutter/material.dart';
import 'package:imdb_app/classes/database.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<int> favorites = [];

  void setFavorites(List<dynamic> ids) {
    favorites.clear();
    for (int id in ids) {
      favorites.add(id);
    }
    notifyListeners();
  }

  Future<void> updateFavorites(int id) async {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    MoviesDatabase.instance.addFavoritesToDB(favorites);
    notifyListeners();
  }

  bool isFavorite(int id) {
    return favorites.contains(id);
  }
}
