import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/core/routes/app_routes.dart';
import 'package:cat_app/core/routes/routes.dart';
import 'package:cat_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:cat_app/features/home/presentation/views/home_view.dart';

void main() {
  group('AppRoutes', () {
    late AppRoutes appRoutes;

    setUp(() {
      appRoutes = const AppRoutes();
    });

    test('should return OnboardingView for onboarding route', () {
      const settings = RouteSettings(name: Routes.onboarding);

      final route = appRoutes.generateRoute(settings);

      expect(route, isA<MaterialPageRoute>());
      final widget = (route as MaterialPageRoute).builder(
        // Create a minimal BuildContext for testing
        _MockBuildContext(),
      );
      expect(widget, isA<OnboardingView>());
    });

    test('should return HomeView for home route', () {
      const settings = RouteSettings(name: Routes.home);

      final route = appRoutes.generateRoute(settings);

      expect(route, isA<MaterialPageRoute>());
      final widget = (route as MaterialPageRoute).builder(_MockBuildContext());
      expect(widget, isA<HomeView>());
    });

    test('should return not found page for unknown route', () {
      const settings = RouteSettings(name: '/unknown');

      final route = appRoutes.generateRoute(settings);

      expect(route, isA<MaterialPageRoute>());
      final widget = (route as MaterialPageRoute).builder(_MockBuildContext());
      expect(widget, isA<Scaffold>());
    });

    testWidgets('should display "Page not found" for unknown route', (
      tester,
    ) async {
      const settings = RouteSettings(name: '/unknown');

      final route = appRoutes.generateRoute(settings);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return (route as MaterialPageRoute).builder(context);
            },
          ),
        ),
      );

      expect(find.text('Page not found'), findsOneWidget);
    });
  });
}

// Mock BuildContext for simple tests
class _MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
