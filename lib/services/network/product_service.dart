import 'package:dio/dio.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/services/network/dio_client.dart';

class ProductService {
  ProductService({DioClient? client}) : _client = client ?? DioClient.instance;

  final DioClient _client;

  // get product list
  Future<ProductResponseModel> getProducts({
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await _client.dio.get(
        '/products',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final data = ProductResponseModel.fromMap(
        response.data as Map<String, dynamic>,
      );

      return data;
    } on DioException catch (e) {
      throw _client.handleError(e);
    }
  }

  // Get product by id
  Future<ProductModel> getProduct(String id) async {
    try {
      final response = await _client.dio.get('/products/$id');
      final data = response.data as Map<String, dynamic>;
      final product = ProductModel.fromMap(data);
      return product;
    } on DioException catch (e) {
      throw _client.handleError(e);
    }
  }

  // search products
  Future<ProductResponseModel> searchProducts(
    String name, {
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await _client.dio.get(
        '/products/search',
        queryParameters: {'q': name, 'limit': limit, 'skip': skip},
      );
      final data = ProductResponseModel.fromMap(
        response.data as Map<String, dynamic>,
      );

      return data;
    } on DioException catch (e) {
      throw _client.handleError(e);
    }
  }

  
}
