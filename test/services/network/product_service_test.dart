import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/services/network/dio_client.dart';
import 'package:product_catalogue/services/network/product_service.dart';

class MockDio extends Mock implements Dio {}

class MockDioClient extends Mock implements DioClient {}

class MockDioException extends Mock implements DioException {}

void main() {
  late MockDio mockDio;
  late MockDioClient mockDioClient;
  late ProductService productService;

  setUp(() {
    mockDio = MockDio();
    mockDioClient = MockDioClient();

    when(() => mockDioClient.dio).thenReturn(mockDio);
    productService = ProductService(client: mockDioClient);
  });

  setUpAll(() {
    registerFallbackValue(MockDioException());
  });

  group('getProducts func', () {
    test(
      'given getProducts func when user func called then return ProductResponseModel',
      () async {
        // arrange

        when(
          () => mockDio.get(
            '/products',
            queryParameters: {'limit': 30, 'skip': 0},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products'),
            statusCode: 200,
            data: {"products": [], "total": 0, "skip": 0, "limit": 30},
          ),
        );

        // act
        final result = await productService.getProducts(limit: 30, skip: 0);

        // assert
        expect(result, isA<ProductResponseModel>());
        verify(() => mockDioClient.dio).called(1);
        verify(
          () => mockDio.get(
            '/products',
            queryParameters: {'limit': 30, 'skip': 0},
          ),
        ).called(1);
      },
    );

    test(
      'given getProducts fuc call and return data when parse response to the model then parse respose in to the ProductResponseModel',
      () async {
        when(
          () => mockDio.get(
            '/products',
            queryParameters: {'limit': 30, 'skip': 0},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products'),
            statusCode: 200,
            data: {
              "products": [
                {
                  "id": 1,
                  "title": "Product 1",
                  "description": "Description 1",
                  "price": 10.0,
                  "rating": 4.5,
                  "category": "Category 1",
                  "images": ["image1.jpg", "image2.jpg"],
                },
              ],
              "total": 1,
              "skip": 0,
              "limit": 30,
            },
          ),
        );

        final result = await productService.getProducts(limit: 30, skip: 0);

        expect(result, isA<ProductResponseModel>());
        expect(result.products.length, equals(1));
        expect(result.products[0].id, equals(1));
        expect(result.products[0].title, equals("Product 1"));
      },
    );

    test(
      'gieven getProducts fuc call when error happens then throws ApiException on DioException',
      () async {
        when(
          () => mockDioClient.handleError(any()),
        ).thenReturn(ApiException('Not Found'));

        when(
          () => mockDio.get(
            '/products',
            queryParameters: {'limit': 30, 'skip': 0},
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/products'),
            type: DioExceptionType.badResponse,
          ),
        );

        final actual = productService.getProducts(limit: 30, skip: 0);

        expect(actual, throwsA(isA<ApiException>()));
      },
    );
  });

  group('searchProducts fuc', () {
    test(
      'given searchProducts func when user call then reurn sorted ProductResponseModel',
      () async {
        when(
          () => mockDio.get(
            '/products/search',
            queryParameters: {'q': 'test', 'limit': 30, 'skip': 0},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products/search'),
            statusCode: 200,
            data: {"products": [], "total": 0, "skip": 0, "limit": 30},
          ),
        );

        final result = await productService.searchProducts(
          'test',
          limit: 30,
          skip: 0,
        );

        expect(result, isA<ProductResponseModel>());
      },
    );
  });
}
