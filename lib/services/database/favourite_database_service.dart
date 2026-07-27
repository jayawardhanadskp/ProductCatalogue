import 'package:hive/hive.dart';
import 'package:product_catalogue/models/product_model.dart';

class FavouriteDatabaseService {
  const FavouriteDatabaseService(this._box);

  static const boxName = 'favorites';

  final Box<ProductModel> _box;

  // get all fav products
  List<ProductModel> getAll() {
    return _box.values.toList();
  }

  // get all fav ids
  Set<int> getAllIds() {
    return _box.keys.map((key) => int.parse(key.toString())).toSet();
  }

  // check items match to the id
  bool contains(int productId) {
    return _box.containsKey(productId.toString());
  }

  // save product
  Future<void> addProduct(ProductModel product) async {
    await _box.put(product.id.toString(), product);
  }

  // del product
  Future<void> remove(int productId) async {
    await _box.delete(productId.toString());
  }
}
