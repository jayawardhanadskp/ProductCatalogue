import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/services/network/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({ProductService? productService})
    : _productService = productService ?? ProductService();
  final ProductService _productService;

  // debounce timer
  Timer? _debounce;

  // product state properties
  final List<ProductModel> _products = [];
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 30;
  String _currentQuery = '';

  // category state properties
  List<String> _categories = [];
  String _selectedCategory = 'All Items';

  // loadings
  bool _isInitialLoading = false;
  bool _isSearchLoading = false;
  bool _isPaginatingLoading = false;
  bool _isCategoryLoading = false;
  bool _isCategoryProductsLoading = false;

  // errors
  String? _initialError;
  String? _searchError;
  String? _paginationError;
  String? _categoryError;

  // getters
  List<ProductModel> get products => _products;
  bool get hasMore => _hasMore;

  bool get isInitialLoading => _isInitialLoading;
  bool get isSearchLoading => _isSearchLoading;
  bool get isPaginatingLoading => _isPaginatingLoading;
  bool get isCategoryLoading => _isCategoryLoading;
  bool get isCategoryProductsLoading => _isCategoryProductsLoading;

  String? get initialError => _initialError;
  String? get searchError => _searchError;
  String? get paginationError => _paginationError;
  String? get categoryError => _categoryError;

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  String get currentQuery => _currentQuery;

  // get initial products
  Future<void> loadInitialProducts() async {
    _isInitialLoading = true;
    _initialError = null;
    _products.clear();
    _skip = 0;
    _hasMore = true;
    _currentQuery = '';
    _selectedCategory = 'All Items';
    notifyListeners();

    try {
      final response = await _productService.getProducts(
        limit: _limit,
        skip: _skip,
      );
      _products.addAll(response.products);
      _updatePaginationControl(response);
    } catch (e) {
      _initialError = e.toString();
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  // load more products
  Future<void> loadMore() async {
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
      } else if (_selectedCategory != 'All Items') {
        response = await _productService.getProductsByCategory(
          _selectedCategory,
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
      _paginationError = e.toString();
    } finally {
      _isPaginatingLoading = false;
      notifyListeners();
    }
  }

  // search products
  Future<void> searchProducts(String query) async {
    _currentQuery = query;
    _selectedCategory = 'All Items';
    _searchError = null;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty && _selectedCategory == 'All Items') {
      await loadInitialProducts();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      _products.clear();
      _skip = 0;
      _hasMore = true;
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
        _searchError = e.toString();
      } finally {
        _isSearchLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadCategoryList() async {
    _isCategoryLoading = true;
    _categoryError = null;
    notifyListeners();

    try {
      final response = await _productService.getCategories();
      _categories = ['All Items', ...response];
    } catch (e) {
      _categoryError = e.toString();
    } finally {
      _isCategoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    _selectedCategory = category;
    _currentQuery = '';
    _products.clear();
    _skip = 0;
    _hasMore = true;
    _categoryError = null;

    if (category == 'All Items') {
      await loadInitialProducts();
      return;
    }

    _isCategoryProductsLoading = true;
    notifyListeners();

    try {
      final response = await _productService.getProductsByCategory(
        category,
        limit: _limit,
        skip: _skip,
      );

      _products.addAll(response.products);
      _updatePaginationControl(response);
    } catch (e) {
      _categoryError = e.toString();
    } finally {
      _isCategoryProductsLoading = false;
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

  // dispose debounce timer
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
