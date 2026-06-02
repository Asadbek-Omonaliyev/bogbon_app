import 'package:bogbon/servis/DatabaseService.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favorites = [];
  List<String> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() {
    _favorites = DatabaseService.getFavoriteIds();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    await DatabaseService.toggleFavorite(id);
    _favorites = DatabaseService.getFavoriteIds();
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  void refresh() {
    _loadFavorites();
  }
}
