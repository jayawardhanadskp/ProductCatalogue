// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

import 'package:product_catalogue/config/app_config.dart';

class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.BASE_URL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json, 
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json',},
        
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  ApiException handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        return ApiException(
          'Server error (${e.response?.statusCode}).',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiException('No internet connection.');
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled.');
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }
}

// exception helper

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
