import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/cat_app.dart';
import 'package:cat_app/core/routes/app_routes.dart';
import 'package:cat_app/core/routes/routes.dart';
import 'package:cat_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  group('CatApp Widget Tests', () {
    testWidgets('should build without errors', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      expect(tester.takeException(), isNull);
    });

    testWidgets('should have MaterialApp', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should have ScreenUtilInit', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      expect(find.byType(ScreenUtilInit), findsOneWidget);
    });

    testWidgets('should disable debug banner', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('should have correct title', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.title, 'Cat App');
    });

    testWidgets('should use Material 3', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.theme?.useMaterial3, true);
    });

    testWidgets('should have teal color scheme', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(
        materialApp.theme?.colorScheme.primary,
        ColorScheme.fromSeed(seedColor: Colors.teal).primary,
      );
    });

    testWidgets('should use onGenerateRoute from AppRoutes', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.onGenerateRoute, isNotNull);
    });

    testWidgets('should have correct design size for ScreenUtilInit', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final screenUtilInit = tester.widget<ScreenUtilInit>(
        find.byType(ScreenUtilInit),
      );

      expect(screenUtilInit.designSize, const Size(375, 812));
    });

    testWidgets('should have minTextAdapt enabled', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final screenUtilInit = tester.widget<ScreenUtilInit>(
        find.byType(ScreenUtilInit),
      );

      expect(screenUtilInit.minTextAdapt, true);
    });

    testWidgets('should have splitScreenMode enabled', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));

      final screenUtilInit = tester.widget<ScreenUtilInit>(
        find.byType(ScreenUtilInit),
      );

      expect(screenUtilInit.splitScreenMode, true);
    });

    testWidgets('should navigate to onboarding as initial route', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // The initial route should be onboarding (/)
      expect(find.byType(OnboardingView), findsOneWidget);
    });

    testWidgets('should accept custom AppRoutes', (tester) async {
      _setTestViewportSize(tester);
      const customRoutes = AppRoutes();

      await tester.pumpWidget(const CatApp(appRoutes: customRoutes));

      final catApp = tester.widget<CatApp>(find.byType(CatApp));

      expect(catApp.appRoutes, customRoutes);
    });

    testWidgets('should be a StatelessWidget', (tester) async {
      const catApp = CatApp(appRoutes: AppRoutes());

      expect(catApp, isA<StatelessWidget>());
    });

    testWidgets('should route to home when navigating to home route', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Navigate to home
      final context = tester.element(find.byType(OnboardingView));
      Navigator.pushNamed(context, Routes.home);
      await tester.pumpAndSettle();

      // Should find the Home text from HomeView
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should show page not found for invalid route', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Navigate to invalid route
      final context = tester.element(find.byType(OnboardingView));
      Navigator.pushNamed(context, '/invalid-route');
      await tester.pumpAndSettle();

      expect(find.text('Page not found'), findsOneWidget);
    });
  });
}

// Helper function to set test viewport size
void _setTestViewportSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
}
