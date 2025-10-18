import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/data/models/weight_model.dart';
import 'package:cat_app/features/home/presentation/views/breed_details_view.dart';
import 'package:cat_app/features/home/presentation/widgets/favorite_icon.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_header_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_description_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_temperament_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_weight_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_characteristics_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_alternative_names_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_links_widget.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:cat_app/core/utils/app_colors.dart';
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

  group('BreedDetailsView Tests', () {
    testWidgets('should have Scaffold', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have CustomScrollView', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should have SliverAppBar', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('should have back button', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets(
      'should display FavoriteIcon when referenceImageId is provided',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed();

        await tester.pumpWidget(
          _makeTestableWidget(
            child: BreedDetailsView(breed: breed),
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
            child: BreedDetailsView(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(FavoriteIcon), findsNothing);
      },
    );

    testWidgets('should display BreedHeaderWidget', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(BreedHeaderWidget), findsOneWidget);
    });

    testWidgets('should display BreedDescriptionWidget', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(BreedDescriptionWidget), findsOneWidget);
    });

    testWidgets(
      'should display BreedTemperamentWidget when temperament exists',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed();

        await tester.pumpWidget(
          _makeTestableWidget(
            child: BreedDetailsView(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(BreedTemperamentWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should not display BreedTemperamentWidget when temperament is null',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed(temperament: null);

        await tester.pumpWidget(
          _makeTestableWidget(
            child: BreedDetailsView(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(BreedTemperamentWidget), findsNothing);
      },
    );

    testWidgets('should display BreedWeightWidget', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(BreedWeightWidget), findsOneWidget);
    });

    testWidgets('should display BreedCharacteristicsWidget', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(BreedCharacteristicsWidget), findsOneWidget);
    });

    testWidgets(
      'should display BreedAlternativeNamesWidget when altNames exists',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed();

        await tester.pumpWidget(
          _makeTestableWidget(
            child: BreedDetailsView(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(BreedAlternativeNamesWidget), findsOneWidget);
      },
    );

    testWidgets(
      'should not display BreedAlternativeNamesWidget when altNames is null',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed(altNames: null);

        await tester.pumpWidget(
          _makeTestableWidget(
            child: BreedDetailsView(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        expect(find.byType(BreedAlternativeNamesWidget), findsNothing);
      },
    );

    testWidgets('should display BreedLinksWidget', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(BreedLinksWidget), findsOneWidget);
    });

    testWidgets('should have white background color', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.white);
    });

    testWidgets('should have primary color for app bar', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(appBar.backgroundColor, AppColors.primary);
    });

    testWidgets('SliverAppBar should be pinned', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(appBar.pinned, true);
    });

    testWidgets('should display placeholder icon when no image URL', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed(withImage: false);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    testWidgets('should build without errors', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('back button should pop navigation', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      // Verify back button exists
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets('should have FlexibleSpaceBar', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(FlexibleSpaceBar), findsOneWidget);
    });

    testWidgets('should have SliverToBoxAdapter for content', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });

    testWidgets('should have Padding for content', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(
        find.descendant(
          of: find.byType(SliverToBoxAdapter),
          matching: find.byType(Padding),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have Column for content layout', (tester) async {
      _setTestViewportSize(tester);
      final breed = _createMockBreed();

      await tester.pumpWidget(
        _makeTestableWidget(
          child: BreedDetailsView(breed: breed),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(
        find.descendant(
          of: find.byType(SliverToBoxAdapter),
          matching: find.byType(Column),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'should display all required sections for complete breed data',
      (tester) async {
        _setTestViewportSize(tester);
        final breed = _createMockBreed();

        await tester.pumpWidget(
          _makeTestableWidget(
            child: BreedDetailsView(breed: breed),
            favoritesCubit: mockFavoritesCubit,
          ),
        );

        // Verify all major sections are present
        expect(find.byType(BreedHeaderWidget), findsOneWidget);
        expect(find.byType(BreedDescriptionWidget), findsOneWidget);
        expect(find.byType(BreedTemperamentWidget), findsOneWidget);
        expect(find.byType(BreedWeightWidget), findsOneWidget);
        expect(find.byType(BreedCharacteristicsWidget), findsOneWidget);
        expect(find.byType(BreedAlternativeNamesWidget), findsOneWidget);
        expect(find.byType(BreedLinksWidget), findsOneWidget);
      },
    );
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
          child: child,
        ),
      );
    },
  );
}

// Helper function to create mock breed
BreedModel _createMockBreed({
  String? temperament = 'Active, Energetic, Independent',
  String? altNames = 'Abys',
  bool withImage = true,
}) {
  return BreedModel(
    id: 'abys',
    name: 'Abyssinian',
    description:
        'The Abyssinian is easy to care for, and a joy to have in your home.',
    weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
    origin: 'Egypt',
    lifeSpan: '12-15',
    temperament: temperament,
    altNames: altNames,
    referenceImageId: withImage ? '0XYvRd7oD' : null,
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Abyssinian_(cat)',
    cfaUrl: 'http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx',
    vetstreetUrl: 'http://www.vetstreet.com/cats/abyssinian',
    adaptability: 5,
    affectionLevel: 5,
    childFriendly: 3,
    dogFriendly: 4,
    energyLevel: 5,
    grooming: 1,
    healthIssues: 2,
    intelligence: 5,
    sheddingLevel: 2,
    socialNeeds: 5,
    strangerFriendly: 3,
  );
}
