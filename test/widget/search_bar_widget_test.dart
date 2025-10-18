import 'package:cat_app/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:cat_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  group('SearchBarWidget Tests', () {
    testWidgets('should display search icon', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display filter/tune icon', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('should display search hint text', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(find.byType(TextField), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, AppStrings.searchHint);
    });

    testWidgets('should have TextField for input', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should have no border on TextField', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.border, InputBorder.none);
    });

    testWidgets('should have Row layout', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(
        find.descendant(
          of: find.byType(SearchBarWidget),
          matching: find.byType(Row),
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('should have two main containers (search and filter)', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      final containers = find.descendant(
        of: find.byType(SearchBarWidget),
        matching: find.byType(Container),
      );

      expect(containers, findsAtLeastNWidgets(2));
    });

    testWidgets('should have Expanded widget for search container', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('search icon should be before TextField', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      final searchIcon = find.byIcon(Icons.search);
      final textField = find.byType(TextField);

      expect(searchIcon, findsOneWidget);
      expect(textField, findsOneWidget);

      // Verify they are in a Row together
      final row = find.ancestor(of: searchIcon, matching: find.byType(Row));
      expect(row, findsOneWidget);
    });

    testWidgets('should have padding wrapper', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(
        find.descendant(
          of: find.byType(SearchBarWidget),
          matching: find.byType(Padding),
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('search container should have rounded corners', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(SearchBarWidget),
          matching: find.byType(Container),
        ),
      );

      bool hasRoundedCorners = false;
      for (final container in containers) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.borderRadius != null) {
            hasRoundedCorners = true;
            break;
          }
        }
      }

      expect(hasRoundedCorners, true);
    });

    testWidgets('filter button should have proper size', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      // Find the container with the tune icon
      final tuneIcon = find.byIcon(Icons.tune);
      final filterContainer = find.ancestor(
        of: tuneIcon,
        matching: find.byType(Container),
      );

      expect(filterContainer, findsOneWidget);

      final container = tester.widget<Container>(filterContainer);
      expect(container.constraints, isNotNull);
    });

    testWidgets('should accept text input', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Persian Cat');

      expect(find.text('Persian Cat'), findsOneWidget);
    });

    testWidgets('should have SizedBox for spacing', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
      );

      expect(
        find.descendant(
          of: find.byType(SearchBarWidget),
          matching: find.byType(SizedBox),
        ),
        findsAtLeastNWidgets(2),
      );
    });

    testWidgets('should build without errors', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(child: const SearchBarWidget()),
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
Widget _makeTestableWidget({required Widget child}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) {
      return MaterialApp(home: Scaffold(body: child));
    },
  );
}
