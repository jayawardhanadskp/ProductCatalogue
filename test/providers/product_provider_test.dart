import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/providers/product_provider.dart';
import 'package:product_catalogue/services/network/dio_client.dart';
import 'package:product_catalogue/services/network/product_service.dart';

class MokProductService extends Mock implements ProductService {}

void main() {
  late MokProductService mockProductService;
  late ProductProvider mockProductProvider;

  setUp(() {
    mockProductService = MokProductService();
    mockProductProvider = ProductProvider(productService: mockProductService);
  });

  group('loadInitialProducts - ', () {
    test(
      'given loadInitialProducts fuction calls when products loads then hasMore works correctly on sucess',
      () async {
        when(() => mockProductService.getProducts()).thenAnswer(
          (_) async => ProductResponseModel(
            products: [
              ProductModel(
                id: 1,
                title: 'title',
                price: 10,
                description: 'description',
                category: 'category',
                images: [],
                rating: 1.1,
              ),
              ProductModel(
                id: 2,
                title: 'title',
                price: 10,
                description: 'description',
                category: 'category',
                images: [],
                rating: 1.1,
              ),
            ],
            total: 2,
            skip: 0,
            limit: 30,
          ),
        );

        await mockProductProvider.loadInitialProducts();

        expect(mockProductProvider.products.length, 2);
        expect(mockProductProvider.hasMore, false);
        expect(mockProductProvider.isInitialLoading, false);
        expect(mockProductProvider.initialError, isNull);
      },
    );

    test(
      'given loadInitialProducts fuc when error occur on call then sets initialError on failure and does not crash',
      () async {
        when(
          () => mockProductService.getProducts(),
        ).thenThrow(ApiException('Networ Error'));

        await mockProductProvider.loadInitialProducts();

        expect(mockProductProvider.products, isEmpty);
        expect(mockProductProvider.initialError, 'Networ Error');
        expect(mockProductProvider.isInitialLoading, false);
      },
    );
  });

  group('loadMore - ', () {
    test(
      'given loadMore fuc when after initailProducts loads and then hasMore == false then do nothing',
      () async {
        when(() => mockProductService.getProducts()).thenAnswer(
          (_) async => ProductResponseModel(
            products: [
              ProductModel(
                id: 1,
                title: 'title',
                price: 10,
                description: 'description',
                category: 'category',
                images: [],
                rating: 1.1,
              ),
            ],
            total: 1,
            skip: 0,
            limit: 30,
          ),
        );

        await mockProductProvider.loadInitialProducts();
        expect(mockProductProvider.hasMore, false);

        await mockProductProvider.loadMore();
        verify(() => mockProductService.getProducts()).called(1);
      },
    );

    test(
      'givem loadMore and when state is loading state then do nothing if request is alredy in the flight',
      () async {
        // arrange
        final completer = Completer<ProductResponseModel>();
        when(
          () => mockProductService.getProducts(),
        ).thenAnswer((_) => completer.future);

        // act
        final loadFirst = mockProductProvider.loadMore();
        expect(mockProductProvider.isPaginatingLoading, true);

        await mockProductProvider.loadMore();

        //assert
        completer.complete(
          ProductResponseModel(
            products: [
              ProductModel(
                id: 1,
                title: 'title',
                price: 10,
                description: 'description',
                category: 'category',
                images: [],
                rating: 1,
              ),
            ],
            total: 10,
            skip: 0,
            limit: 30,
          ),
        );

        await loadFirst;

        verify(() => mockProductService.getProducts()).called(1);
      },
    );
  });

  group('searchProducts debounce- ', () {
    test(
      'when user sequensly type then only calls the API once at the time of debounce ',
      () async {
        when(() => mockProductService.searchProducts(any())).thenAnswer(
          (_) async =>
              ProductResponseModel(products: [], total: 10, skip: 0, limit: 30),
        );

        mockProductProvider.searchProducts('q');
        mockProductProvider.searchProducts('qq');
        mockProductProvider.searchProducts('qqq');

        await Future.delayed(const Duration(milliseconds: 300));

        verify(() => mockProductService.searchProducts('qqq')).called(1);

        verifyNever(() => mockProductService.searchProducts('q'));
        verifyNever(() => mockProductService.searchProducts('qq'));
      },
    );
  });
}
