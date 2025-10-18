import 'package:cat_app/features/home/presentation/widgets/category_chip_widget.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  group('CategoryChipWidget Tests', () {
    testWidgets('should display label text', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Cats'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      _setTestViewportSize(tester);
      bool wasTapped = false;

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(CategoryChipWidget));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('should have primary color when selected', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });

    testWidgets('should have transparent color when not selected', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.transparent);
    });

    testWidgets('should have primary border color when selected', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());

      final border = decoration.border as Border;
      expect(border.top.color, AppColors.primary);
    });

    testWidgets('should have grey border color when not selected', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());
    });

    testWidgets('should have white text color when selected', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Cats'));
      expect(text.style?.color, AppColors.white);
    });

    testWidgets('should have different text color when not selected', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Cats'));
      expect(text.style?.color, isNot(AppColors.white));
    });

    testWidgets('should have rounded corners', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('should have GestureDetector', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should have Container with padding', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
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

    testWidgets('should handle long label text', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Very Long Category Name',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Very Long Category Name'), findsOneWidget);
    });

    testWidgets('should handle empty label', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(label: '', isSelected: false, onTap: () {}),
        ),
      );

      expect(find.byType(CategoryChipWidget), findsOneWidget);
    });

    testWidgets('should toggle visual state when isSelected changes', (
      tester,
    ) async {
      _setTestViewportSize(tester);

      // First render as not selected
      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      var container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.transparent);

      // Now render as selected
      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });

    testWidgets('should build without errors', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: CategoryChipWidget(
            label: 'Cats',
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple chips can be displayed together', (tester) async {
      _setTestViewportSize(tester);

      await tester.pumpWidget(
        _makeTestableWidget(
          child: Row(
            children: [
              CategoryChipWidget(label: 'Cats', isSelected: true, onTap: () {}),
              CategoryChipWidget(
                label: 'Dogs',
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Cats'), findsOneWidget);
      expect(find.text('Dogs'), findsOneWidget);
      expect(find.byType(CategoryChipWidget), findsNWidgets(2));
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
