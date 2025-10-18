import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:cat_app/features/home/presentation/widgets/favorite_icon.dart';
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

  group('FavoriteIcon Widget Tests', () {
    testWidgets('should display favorite_border icon when not favorited', (
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
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should display favorite icon when favorited', (tester) async {
      _setTestViewportSize(tester);
      when(() => mockFavoritesCubit.state).thenReturn(
        const FavoritesState(
          status: FavoritesStatus.success,
          favorites: [],
          favoriteImageIds: {'test_image_id'},
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          const FavoritesState(
            status: FavoritesStatus.success,
            favorites: [],
            favoriteImageIds: {'test_image_id'},
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should call toggleFavorite when tapped', (tester) async {
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
      when(
        () => mockFavoritesCubit.toggleFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      await tester.tap(find.byType(FavoriteIcon));
      await tester.pump();

      verify(
        () => mockFavoritesCubit.toggleFavorite(
          imageId: 'test_image_id',
          subId: null,
        ),
      ).called(1);
    });

    testWidgets('should pass subId when provided', (tester) async {
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
      when(
        () => mockFavoritesCubit.toggleFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoriteIcon(
            imageId: 'test_image_id',
            subId: 'test_sub_id',
          ),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      await tester.tap(find.byType(FavoriteIcon));
      await tester.pump();

      verify(
        () => mockFavoritesCubit.toggleFavorite(
          imageId: 'test_image_id',
          subId: 'test_sub_id',
        ),
      ).called(1);
    });

    testWidgets('should have primary color for icon', (tester) async {
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
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.favorite_border));
      expect(icon.color, AppColors.primary);
    });

    testWidgets('should have proper icon size', (tester) async {
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
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.favorite_border));
      expect(icon.size, isNotNull);
    });

    testWidgets('should be wrapped in GestureDetector', (tester) async {
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
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(
        find.descendant(
          of: find.byType(FavoriteIcon),
          matching: find.byType(GestureDetector),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should be wrapped in Container with padding', (tester) async {
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
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      expect(container.padding, isNotNull);
    });

    testWidgets('should update icon when state changes', (tester) async {
      _setTestViewportSize(tester);

      // Start with not favorited
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
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Update to favorited
      when(() => mockFavoritesCubit.state).thenReturn(
        const FavoritesState(
          status: FavoritesStatus.success,
          favorites: [],
          favoriteImageIds: {'test_image_id'},
        ),
      );
      when(() => mockFavoritesCubit.stream).thenAnswer(
        (_) => Stream.value(
          const FavoritesState(
            status: FavoritesStatus.success,
            favorites: [],
            favoriteImageIds: {'test_image_id'},
          ),
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(
          child: const FavoriteIcon(imageId: 'test_image_id'),
          favoritesCubit: mockFavoritesCubit,
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
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
