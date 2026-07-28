import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/providers/favourite_provider.dart';
import 'package:product_catalogue/services/database/favourite_database_service.dart';

class MockFavDatabaseService extends Mock implements FavouriteDatabaseService {}

void main() {
  late MockFavDatabaseService mockFavDatabaseService;
  late FavouriteProvider favouriteProvider;

  final sampleProduct = ProductModel(
    id: 42,
    title: 'Test Product',
    description: 'description',
    price: 19.99,
    rating: 4.5,
    category: 'category',
    images: [],
  );

  setUp(() {
    mockFavDatabaseService = MockFavDatabaseService();
    favouriteProvider = FavouriteProvider(mockFavDatabaseService);
  });

  group('FavouriteProvider - ', () {
    group('initFunctio', () {
      test(
        'shoud fetch all the ids from database and mark provider as redy',
        () async {
          // arrange
          final mockIds = {1, 2, 3};
          when(() => mockFavDatabaseService.getAllIds()).thenReturn(mockIds);

          //act
          favouriteProvider.init();

          // assert
          expect(favouriteProvider.isReady, isTrue);
          verify(() => mockFavDatabaseService.getAllIds()).called(1);
        },
      );
    });

    group('favorites getter', () {
      test(
        'shoud return full list of the favorites productModel form the database',
        () async {
          // arrange
          final mockFavProducts = [sampleProduct, sampleProduct];
          when(
            () => mockFavDatabaseService.getAll(),
          ).thenReturn(mockFavProducts);

          // act
          final results = favouriteProvider.favourites;

          // assert
          expect(results, equals(mockFavProducts));
          verify(() => mockFavDatabaseService.getAll()).called(1);
        },
      );
    });

    // FAVORITE TOGGLE
    group('toggleFavorite func', () {
      test(
        'given non favorite product when toggle fav button then add to favorite, runs db call, return true',
        () async {
          when(
            () => mockFavDatabaseService.addProduct(sampleProduct),
          ).thenAnswer((_) async {});

          final result = await favouriteProvider.toggleFavorite(sampleProduct);

          expect(result, isTrue);
          verify(
            () => mockFavDatabaseService.addProduct(sampleProduct),
          ).called(1);
        },
      );

      test(
        'given favorite product whe  toggle fav button the remove from favorite , runs db call, rerun true',
        () async {
          // arrange
          when(() => mockFavDatabaseService.getAllIds()).thenReturn({42});
          favouriteProvider.init();
          when(
            () => mockFavDatabaseService.remove(42),
          ).thenAnswer((_) async {});

          // act
          final result = await favouriteProvider.toggleFavorite(sampleProduct);

          // assert
          expect(result, isTrue);
          verify(() => mockFavDatabaseService.remove(42)).called(1);
        },
      );

      
    });
  });
}
