import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/cat_app.dart';
import 'package:cat_app/core/routes/app_routes.dart';
import 'package:cat_app/core/di/injection_container.dart' as di;

/// Integration tests for the Onboarding feature
/// Tests the onboarding screen display and navigation flow
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize dependencies
    await di.init();
  });

  group('Onboarding Screen', () {
    testWidgets('Displays onboarding content correctly', (tester) async {
      // Build the app starting at onboarding
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Verify onboarding image is displayed
      expect(find.byType(Image), findsAtLeastNWidgets(1));

      // Verify onboarding title text is present
      expect(find.textContaining('Cat'), findsAtLeastNWidgets(1));

      // Verify Get Started button is present
      expect(find.text('Get Started'), findsOneWidget);

      // Verify button has pet icon
      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    testWidgets('Get Started button navigates to main navigation', (
      tester,
    ) async {
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Find and tap the Get Started button
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);

      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify navigation occurred by checking for main navigation elements
      // Should see bottom navigation bar with home, favorites, etc.
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.favorite_border), findsAtLeastNWidgets(1));

      // Onboarding should not be visible anymore
      expect(find.text('Get Started'), findsNothing);
    });

    testWidgets('Onboarding screen layout is correct', (tester) async {
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Verify the scaffold exists
      expect(find.byType(Scaffold), findsWidgets);

      // Verify column layout exists
      expect(find.byType(Column), findsWidgets);

      // Verify button is tappable and visible
      final getStartedButton = find.text('Get Started');
      expect(tester.widget<Widget>(getStartedButton), isNotNull);
    });

    testWidgets('Button responds to tap', (tester) async {
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      final getStartedButton = find.text('Get Started');

      // Ensure button is present
      expect(getStartedButton, findsOneWidget);

      // Tap the button
      await tester.tap(getStartedButton);
      await tester.pump(); // Start the animation
      await tester.pump(
        const Duration(milliseconds: 100),
      ); // Animation in progress

      // Should start navigating
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should be on a different screen now
      expect(find.text('Get Started'), findsNothing);
    });
  });

  group('Onboarding Navigation', () {
    testWidgets('Cannot navigate back from onboarding', (tester) async {
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Verify we're on onboarding
      expect(find.text('Get Started'), findsOneWidget);

      // Try to pop (there should be no back button/action on onboarding)
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      final canPop = navigator.canPop();

      // Onboarding should be the first screen, so cannot pop
      expect(canPop, isFalse);
    });

    testWidgets('After navigation, cannot go back to onboarding', (
      tester,
    ) async {
      await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
      await tester.pumpAndSettle();

      // Navigate to main navigation
      final getStartedButton = find.text('Get Started');
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify we're on main navigation
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));

      // Try to pop back
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      final canPop = navigator.canPop();

      // Should not be able to pop back since we used pushReplacement
      expect(canPop, isFalse);
    });
  });
}
