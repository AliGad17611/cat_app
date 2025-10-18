import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/features/home/presentation/views/home_view.dart';

void main() {
  group('HomeView Widget Tests', () {
    testWidgets('should display Home text', (tester) async {
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should have Scaffold', (tester) async {
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have Center widget', (tester) async {
      await tester.pumpWidget(_makeTestableWidget());

      final scaffold = find.byType(Scaffold);
      final center = find.descendant(
        of: scaffold,
        matching: find.byType(Center),
      );

      expect(center, findsOneWidget);
    });

    testWidgets('should center the text', (tester) async {
      await tester.pumpWidget(_makeTestableWidget());

      // Verify that the text is inside a Center widget
      final centerFinder = find.ancestor(
        of: find.text('Home'),
        matching: find.byType(Center),
      );

      expect(centerFinder, findsOneWidget);
    });

    testWidgets('should be a StatelessWidget', (tester) async {
      const homeView = HomeView();

      expect(homeView, isA<StatelessWidget>());
    });

    testWidgets('should build without errors', (tester) async {
      await tester.pumpWidget(_makeTestableWidget());

      // Verify that the widget tree is built correctly
      expect(tester.takeException(), isNull);
    });
  });
}

// Helper function to wrap widget with MaterialApp
Widget _makeTestableWidget() {
  return const MaterialApp(home: HomeView());
}
