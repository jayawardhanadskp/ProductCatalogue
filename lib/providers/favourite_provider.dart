import 'package:flutter/material.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/services/database/favourite_database_service.dart';

class FavouriteProvider extends ChangeNotifier {
  FavouriteProvider(this._favouriteService);

  final FavouriteDatabaseService _favouriteService;

  final Set<int> _favoriteIds = {};

  bool _isReady = false;

  bool get isReady => _isReady;

  void init() {
    _favoriteIds
      ..clear()
      ..addAll(_favouriteService.getAllIds());
    _isReady = true;
    notifyListeners();
  }

  // check product is fav
  bool isFavourite(int productId) => _favouriteService.contains(productId);

  // getter for full fav item list
  List<ProductModel> get favourites => _favouriteService.getAll();

  // toggle favourites
  Future<bool> toggleFavorite(ProductModel product) async {
    final int productId = product.id;
    final bool wasFavorite = _favoriteIds.contains(productId);

    // optimistic ui update
    if (wasFavorite) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();

    try {
      // database operation in background
      if (wasFavorite) {
        await _favouriteService.remove(productId);
      } else {
        await _favouriteService.addProduct(product);
      }

      return true;
    } catch (error) {
      // 3. rollback if database fails
      if (wasFavorite) {
        _favoriteIds.add(productId);
      } else {
        _favoriteIds.remove(productId);
      }
      notifyListeners();
      print('Failed to update favorite in storage: $error');

      return false;
    }
  }
}
