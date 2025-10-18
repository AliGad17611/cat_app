import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/home/data/repositories/home_repository.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/data/models/weight_model.dart';
import 'package:cat_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:cat_app/features/home/presentation/cubit/home_state.dart';
import 'package:flutter/material.dart';

@GenerateMocks([HomeRepository])
import 'home_cubit_test.mocks.dart';

void main() {
  late HomeCubit cubit;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    cubit = HomeCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final tBreedsList = [
    BreedModel(
      weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
      id: 'abys',
      name: 'Abyssinian',
      description: 'Test description',
      lifeSpan: '14 - 15',
      origin: 'Egypt',
      temperament: 'Active, Energetic',
      referenceImageId: '0XYvRd7oD',
    ),
    BreedModel(
      weight: WeightModel(imperial: '5 - 9', metric: '2 - 4'),
      id: 'aege',
      name: 'Aegean',
      description: 'Test description 2',
      lifeSpan: '9 - 12',
      origin: 'Greece',
      temperament: 'Affectionate, Social',
      referenceImageId: 'ozEvzdVM-',
    ),
  ];

  final tBreedsList2 = [
    BreedModel(
      weight: WeightModel(imperial: '6 - 11', metric: '3 - 5'),
      id: 'abob',
      name: 'American Bobtail',
      description: 'Test description 3',
      lifeSpan: '11 - 15',
      origin: 'United States',
      temperament: 'Intelligent, Interactive',
      referenceImageId: 'hBXicehMA',
    ),
  ];

  group('HomeCubit', () {
    test('initial state should be HomeState with initial status', () {
      expect(cubit.state, equals(const HomeState()));
      expect(cubit.state.status, equals(HomeStatus.initial));
      expect(cubit.state.breeds, equals([]));
      expect(cubit.state.currentPage, equals(0));
      expect(cubit.state.hasReachedEnd, equals(false));
    });

    group('loadBreeds', () {
      blocTest<HomeCubit, HomeState>(
        'emits [loading, success] when data is loaded successfully',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => tBreedsList);
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            breeds: tBreedsList,
            currentPage: 1,
            hasReachedEnd: false,
          ),
        ],
        verify: (_) {
          verify(mockRepository.getBreeds(page: 0, limit: 20)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits [loading, reachedEnd] when empty list is returned',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => []);
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(status: HomeStatus.reachedEnd, hasReachedEnd: true),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'emits [loadingMore, success] when loading more data',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => tBreedsList2);
          return cubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 1,
        ),
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          HomeState(
            status: HomeStatus.loadingMore,
            breeds: tBreedsList,
            currentPage: 1,
          ),
          HomeState(
            status: HomeStatus.success,
            breeds: [...tBreedsList, ...tBreedsList2],
            currentPage: 2,
            hasReachedEnd: false,
          ),
        ],
        verify: (_) {
          verify(mockRepository.getBreeds(page: 1, limit: 20)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits [loading, failure] when ApiErrorModel is thrown',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(
            ApiErrorModel(
              message: 'No internet connection',
              statusCode: null,
              icon: Icons.wifi_off,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'No internet connection',
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'emits [loading, failure] with server error message',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(
            ApiErrorModel(
              message: 'Server error, please try again later',
              statusCode: 500,
              icon: Icons.error,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'Server error, please try again later',
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'emits failure with generic message for unexpected error',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(Exception('Unexpected error'));
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'An unexpected error occurred',
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'does not load more when hasReachedEnd is true',
        build: () => cubit,
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 5,
          hasReachedEnd: true,
        ),
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );
    });

    group('refreshBreeds', () {
      blocTest<HomeCubit, HomeState>(
        'emits [loading, success] with fresh data when refresh is successful',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => tBreedsList2);
          return cubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 3,
          hasReachedEnd: true,
        ),
        act: (cubit) => cubit.refreshBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            breeds: tBreedsList2,
            currentPage: 1,
            hasReachedEnd: false,
          ),
        ],
        verify: (_) {
          verify(mockRepository.getBreeds(page: 0, limit: 20)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits [loading, failure] when refresh fails',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(
            ApiErrorModel(
              message: 'Connection timeout',
              statusCode: null,
              icon: Icons.timer_off,
            ),
          );
          return cubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 1,
        ),
        act: (cubit) => cubit.refreshBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'Connection timeout',
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'resets page to 0 when refreshing',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => tBreedsList);
          return cubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 5,
        ),
        act: (cubit) => cubit.refreshBreeds(),
        verify: (_) {
          verify(mockRepository.getBreeds(page: 0, limit: 20)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'allows loading even when hasReachedEnd is true',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => tBreedsList);
          return cubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 5,
          hasReachedEnd: true,
        ),
        act: (cubit) => cubit.refreshBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            breeds: tBreedsList,
            currentPage: 1,
            hasReachedEnd: false,
          ),
        ],
      );
    });

    group('loadMoreBreeds', () {
      blocTest<HomeCubit, HomeState>(
        'calls loadBreeds when status is not loadingMore and not reached end',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => tBreedsList2);
          return cubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 1,
        ),
        act: (cubit) => cubit.loadMoreBreeds(),
        expect: () => [
          HomeState(
            status: HomeStatus.loadingMore,
            breeds: tBreedsList,
            currentPage: 1,
          ),
          HomeState(
            status: HomeStatus.success,
            breeds: [...tBreedsList, ...tBreedsList2],
            currentPage: 2,
            hasReachedEnd: false,
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'does not call loadBreeds when already loading more',
        build: () => cubit,
        seed: () => HomeState(
          status: HomeStatus.loadingMore,
          breeds: tBreedsList,
          currentPage: 1,
        ),
        act: (cubit) => cubit.loadMoreBreeds(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );

      blocTest<HomeCubit, HomeState>(
        'does not call loadBreeds when hasReachedEnd is true',
        build: () => cubit,
        seed: () => HomeState(
          status: HomeStatus.success,
          breeds: tBreedsList,
          currentPage: 5,
          hasReachedEnd: true,
        ),
        act: (cubit) => cubit.loadMoreBreeds(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );
    });

    group('error scenarios', () {
      blocTest<HomeCubit, HomeState>(
        'handles 404 error correctly',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(
            ApiErrorModel(
              message: 'Not found',
              statusCode: 404,
              icon: Icons.search_off,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'Not found',
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'handles 401 unauthorized error',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(
            ApiErrorModel(
              message: 'Unauthorized',
              statusCode: 401,
              icon: Icons.lock,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'Unauthorized',
          ),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'handles validation error (400)',
        build: () {
          when(
            mockRepository.getBreeds(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(
            ApiErrorModel(
              message: 'Validation failed',
              statusCode: 400,
              icon: Icons.warning,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadBreeds(),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.failure,
            errorMessage: 'Validation failed',
          ),
        ],
      );
    });
  });
}
