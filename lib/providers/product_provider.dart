import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/services/network/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({ProductService? productService})
    : _productService = productService ?? ProductService();
  final ProductService _productService;

  // state properties
  final List<ProductModel> _products = [];
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 30;
  String _currentQuery = '';

  // loadings
  bool _isInitialLoading = false;
  bool _isSearchLoading = false;
  bool _isPaginatingLoading = false;

  // errors
  String? _initialError;
  String? _searchError;
  String? _paginationError;

  // getters
  List<ProductModel> get products => _products;
  bool get hasMore => _hasMore;

  bool get isInitialLoading => _isInitialLoading;
  bool get isSearchLoading => _isSearchLoading;
  bool get isPaginatingLoading => _isPaginatingLoading;

  String? get initialError => _initialError;
  String? get searchError => _searchError;
  String? get paginationError => _paginationError;

  // get initial products
  Future<void> loadInitialProducts() async {
    _isInitialLoading = true;
    _initialError = null;
    _products.clear();
    _skip = 0;
    _hasMore = true;
    _currentQuery = '';
    notifyListeners();

    try {
      final response = await _productService.getProducts(
        limit: _limit,
        skip: _skip,
      );
      _products.addAll(response.products);
      _updatePaginationControl(response);
    } catch (e) {
      print(e.toString());
      _initialError = e.toString();
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  // load more products
  Future<void> loadMore() async {
    print('load more');
    if (_isInitialLoading ||
        _isSearchLoading ||
        _isPaginatingLoading ||
        !_hasMore) {
      return;
    }
    _isPaginatingLoading = true;
    _paginationError = null;
    notifyListeners();

    try {
      ProductResponseModel response;

      if (_currentQuery.isEmpty) {
        response = await _productService.getProducts(
          limit: _limit,
          skip: _skip,
        );
      } else {
        response = await _productService.searchProducts(
          _currentQuery,
          limit: _limit,
          skip: _skip,
        );
      }

      _products.addAll(response.products);
      _updatePaginationControl(response);
    } catch (e) {
      print(e.toString());
      _paginationError = e.toString();
    } finally {
      _isPaginatingLoading = false;
      notifyListeners();
    }
  }

  // search products
  Future<void> searchProducts(String query) async {
    _currentQuery = query;
    _products.clear();
    _skip = 0;
    _hasMore = true;
    _searchError = null;

    if (query.isEmpty) {
      await loadInitialProducts();
      return;
    }

    _isSearchLoading = true;
    notifyListeners();

    try {
      final response = await _productService.searchProducts(
        _currentQuery,
        limit: _limit,
        skip: _skip,
      );

      _products.addAll(response.products);
      _updatePaginationControl(response);
    } catch (e) {
      print(e);
      _searchError = e.toString();
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  // pagination HELPER =========================================================
  void _updatePaginationControl(ProductResponseModel response) {
    if (products.length >= response.total) {
      _hasMore = false;
    } else {
      _skip = response.skip + response.limit;
    }
  }
}
