import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/data/models/weight_model.dart';
import 'package:cat_app/features/home/presentation/widgets/pet_card_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/favorite_icon.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockFavoritesCubit extends Mock implements FavoritesCubit {}

void main() {
  late MockFavoritesCubit mockFavoritesCubit;

  setUp(() {
    mockFavoritesCubit = MockFavoritesCubit();
    when(() => mockFavoritesCubit.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.success,
        favorites: [],
        favoriteImageIds: {},
      ),
    );
    when(() => mockFavoritesCubit.stream).thenAnswer(
      (_) => Stream.value(
        const FavoritesState(
          status: FavoritesStatus.success,
          favorites: [],
          favoriteImageIds: {},
        ),
      ),
    );
  });

  group('PetCardWidget Tests', () {
    testWidgets('should display breed name', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.text('Abyssinian'), findsOneWidget);
    });

    testWidgets('should display breed origin when available', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.textContaining('Origin: Egypt'), findsOneWidget);
    });

    testWidgets('should display breed life span when available', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.textContaining('Life span: 12-15 years'), findsOneWidget);
    });

    testWidgets('should display breed temperament when available', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.sentiment_satisfied_alt), findsOneWidget);
      expect(find.textContaining('Active'), findsOneWidget);
    });

    testWidgets('should display placeholder icon when no image URL', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed(withImage: false);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    testWidgets(
      'should display FavoriteIcon when referenceImageId is provided',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed();

        await tester.pumpWidget(
          _makeTestableWidget(
            child: PetCardWidget(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(FavoriteIcon), findsOneWidget);
      },
    );

    testWidgets(
      'should not display FavoriteIcon when referenceImageId is null',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed(withImage: false);

        await tester.pumpWidget(
          _makeTestableWidget(
            child: PetCardWidget(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(FavoriteIcon), findsNothing);
      },
    );

    testWidgets('should be tappable', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should have proper container styling', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(GestureDetector),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow?.isNotEmpty, true);
    });

    testWidgets('should display image container with proper dimensions', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final imageContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ClipRRect),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(imageContainer.constraints, isNotNull);
    });

    testWidgets('should use Row layout for content', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final rows = find.descendant(
        of: find.byType(PetCardWidget),
        matching: find.byType(Row),
      );

      expect(rows, findsAtLeastNWidgets(1));
    });

    testWidgets('should truncate long temperament text', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed(
        temperament:
            'Active, Energetic, Independent, Intelligent, Gentle, Playful, Social',
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      // Should only show first 2 temperaments
      final textWidget = tester.widget<Text>(find.textContaining('Active'));
      expect(textWidget.maxLines, 1);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should not display origin when null', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed(origin: null);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.textContaining('Origin:'), findsNothing);
    });

    testWidgets('should not display life span when null', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed(lifeSpan: null);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.textContaining('Life span:'), findsNothing);
    });

    testWidgets('should not display temperament when null', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed(temperament: null);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: PetCardWidget(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.sentiment_satisfied_alt), findsNothing);
    });
  });
}

// Helper function to set test viewport size
void _setTestViewportSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
}

// Helper function to wrap widget with MaterialApp and ScreenUtilInit
Widget _makeTestableWidget({
  required Widget child,
  required FavoritesCubit favoritesCubit,
}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) {
      return MaterialApp(
        home: BlocProvider<FavoritesCubit>.value(
          value: favoritesCubit,
          child: Scaffold(body: child),
        ),
      );
    },
  );
}

// Helper function to create mock breed
BreedModel _createMockBreed({
  String? origin = 'Egypt',
  String? lifeSpan = '12-15',
  String? temperament = 'Active, Energetic, Independent',
  bool withImage = true,
}) {
  return BreedModel(
    id: 'abys',
    name: 'Abyssinian',
    description:
        'The Abyssinian is easy to care for, and a joy to have in your home.',
    weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
    origin: origin,
    lifeSpan: lifeSpan,
    temperament: temperament,
    referenceImageId: withImage ? '0XYvRd7oD' : null,
  );
}
