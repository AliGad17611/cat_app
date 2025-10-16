/// Main test suite file that imports all test files
/// Run this with: flutter test test/test_suite.dart
library;

// Unit Tests
import 'unit/cache_helper_test.dart' as cache_helper_test;
import 'unit/api_error_model_test.dart' as api_error_model_test;
import 'unit/app_routes_test.dart' as app_routes_test;

// Widget Tests
import 'widget/primary_button_test.dart' as primary_button_test;
import 'widget/onboarding_view_test.dart' as onboarding_view_test;
import 'widget/home_view_test.dart' as home_view_test;
import 'widget/cat_app_test.dart' as cat_app_test;

void main() {
  // Unit Tests
  cache_helper_test.main();
  api_error_model_test.main();
  app_routes_test.main();

  // Widget Tests
  primary_button_test.main();
  onboarding_view_test.main();
  home_view_test.main();
  cat_app_test.main();
}
