import 'package:cat_app/features/favorites/data/models/favorite_model.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:cat_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:cat_app/features/favorites/presentation/widgets/favorite_card_widget.dart';
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
  });

  group('FavoritesView Tests', () {
    testWidgets('should have Scaffold', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display title "Your Favorite Pets"', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.text('Your Favorite Pets'), findsOneWidget);
    });

    testWidgets('should display loading indicator when status is loading', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      when(() => mockFavoritesCubit.state).thenReturn(
        const FavoritesState(
          status: FavoritesStatus.loading,
          favorites: [],
          favoriteImageIds: {},
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          const FavoritesState(
            status: FavoritesStatus.loading,
            favorites: [],
            favoriteImageIds: {},
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display empty state when favorites list is empty', (
      tester,
    ) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.text('No favorites yet'), findsOneWidget);
      expect(find.text('Start adding your favorite cats!'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should display error state when status is failure', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      when(() => mockFavoritesCubit.state).thenReturn(
        const FavoritesState(
          status: FavoritesStatus.failure,
          favorites: [],
          favoriteImageIds: {},
          errorMessage: 'Failed to load favorites',
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          const FavoritesState(
            status: FavoritesStatus.failure,
            favorites: [],
            favoriteImageIds: {},
            errorMessage: 'Failed to load favorites',
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.text('Failed to load favorites'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should call loadFavorites when retry button is tapped', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      when(() => mockFavoritesCubit.state).thenReturn(
        const FavoritesState(
          status: FavoritesStatus.failure,
          favorites: [],
          favoriteImageIds: {},
          errorMessage: 'Failed to load favorites',
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          const FavoritesState(
            status: FavoritesStatus.failure,
            favorites: [],
            favoriteImageIds: {},
            errorMessage: 'Failed to load favorites',
          ),
        ),
      );
      when(() => mockFavoritesCubit.loadFavorites()).thenAnswer((_) async {});

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => mockFavoritesCubit.loadFavorites()).called(1);
    });

    testWidgets('should display favorites in GridView when data is available', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final favorites = [
        FavoriteModel(
          id: 1,
          imageId: 'test_image_1',
          subId: 'test_sub_1',
          createdAt: DateTime.now().toIso8601String(),
        ),
        FavoriteModel(
          id: 2,
          imageId: 'test_image_2',
          subId: 'test_sub_2',
          createdAt: DateTime.now().toIso8601String(),
        ),
      ];

      when(() => mockFavoritesCubit.state).thenReturn(
        FavoritesState(
          status: FavoritesStatus.success,
          favorites: favorites,
          favoriteImageIds: {'test_image_1', 'test_image_2'},
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: favorites,
            favoriteImageIds: {'test_image_1', 'test_image_2'},
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(FavoriteCardWidget), findsNWidgets(2));
    });

    testWidgets('should have RefreshIndicator for pull to refresh', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      final favorites = [
        FavoriteModel(
          id: 1,
          imageId: 'test_image_1',
          subId: 'test_sub_1',
          createdAt: DateTime.now().toIso8601String(),
        ),
      ];

      when(() => mockFavoritesCubit.state).thenReturn(
        FavoritesState(
          status: FavoritesStatus.success,
          favorites: favorites,
          favoriteImageIds: {'test_image_1'},
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: favorites,
            favoriteImageIds: {'test_image_1'},
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should display category tabs', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Cats'), findsOneWidget);
      expect(find.text('Dogs'), findsOneWidget);
      expect(find.text('Birds'), findsOneWidget);
      expect(find.text('Fish'), findsOneWidget);
      expect(find.text('Reptiles'), findsOneWidget);
    });

    testWidgets('should have "All" category selected by default', (
      tester,
    ) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      // Find the container for "All" category
      final allCategoryContainers = tester.widgetList<Container>(
        find.descendant(
          of: find.ancestor(
            of: find.text('All'),
            matching: find.byType(Container),
          ),
          matching: find.byType(Container),
        ),
      );

      // Check if any container has primary color (selected state)
      bool hasSelectedStyle = false;
      for (final container in allCategoryContainers) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color == AppColors.primary) {
            hasSelectedStyle = true;
            break;
          }
        }
      }

      expect(hasSelectedStyle, true);
    });

    testWidgets('should have SafeArea', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should have white background color', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.white);
    });

    testWidgets('should have Column layout in SafeArea', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(
        find.descendant(
          of: find.byType(SafeArea),
          matching: find.byType(Column),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have Padding for content', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should have SingleChildScrollView for category tabs', (
      tester,
    ) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display error icon when provided', (tester) async {
      _setTestViewportSize(tester);
      when(() => mockFavoritesCubit.state).thenReturn(
        const FavoritesState(
          status: FavoritesStatus.failure,
          favorites: [],
          favoriteImageIds: {},
          errorMessage: 'Network error',
          errorIcon: Icons.wifi_off,
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          const FavoritesState(
            status: FavoritesStatus.failure,
            favorites: [],
            favoriteImageIds: {},
            errorMessage: 'Network error',
            errorIcon: Icons.wifi_off,
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('should build without errors', (tester) async {
      _setTestViewportSize(tester);
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

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoritesView(),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(tester.takeException(), isNull);
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
          child: child,
        ),
      );
    },
  );
}
