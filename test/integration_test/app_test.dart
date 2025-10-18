import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cat_app/main.dart' as app;
import 'package:flutter/material.dart';

/// Main integration test that verifies the overall app flow
/// Tests the complete user journey from app launch to navigation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cat App - Main Flow', () {
    testWidgets('App launches successfully and loads initial screen', (
      tester,
    ) async {
      // Start the app
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify the app loads and shows some content
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Complete user flow: Onboarding to Home navigation', (
      tester,
    ) async {
      // Start the app
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if we're on onboarding or main navigation
      final getStartedButton = find.text('Get Started');

      if (tester.any(getStartedButton)) {
        // We're on onboarding, tap the button
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Now we should be on main navigation
      // Verify bottom navigation bar exists
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.favorite_border), findsAtLeastNWidgets(1));
    });
  });

  group('Cat App - Navigation', () {
    testWidgets('Navigate between tabs in main navigation', (tester) async {
      // Start the app
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding if present
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find navigation items
      final homeIcon = find.byIcon(Icons.home);
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      final chatIcon = find.byIcon(Icons.chat_bubble_outline);
      final profileIcon = find.byIcon(Icons.person_outline);

      // Verify all navigation items exist
      expect(homeIcon, findsAtLeastNWidgets(1));
      expect(favoritesIcon, findsAtLeastNWidgets(1));
      expect(chatIcon, findsWidgets);
      expect(profileIcon, findsWidgets);

      // Test navigation to Favorites
      final favoritesNavButton = favoritesIcon.first;
      await tester.tap(favoritesNavButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test navigation to Chat
      final chatNavButton = chatIcon.first;
      await tester.tap(chatNavButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Chat Feature'), findsOneWidget);
      expect(find.text('Coming Soon!'), findsAtLeastNWidgets(1));

      // Test navigation to Profile
      final profileNavButton = profileIcon.first;
      await tester.tap(profileNavButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Profile Feature'), findsOneWidget);

      // Navigate back to Home
      final homeNavButton = homeIcon.first;
      await tester.tap(homeNavButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });

  group('Cat App - Error Handling', () {
    testWidgets('App handles navigation gracefully', (tester) async {
      // Start the app
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // The app should not crash and should show some UI
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
