# Unit Tests Quick Reference

## 🚀 Quick Start

### First Time Setup
```bash
# 1. Generate mocks (REQUIRED before first run)
dart run build_runner build --delete-conflicting-outputs

# 2. Run tests
flutter test
```

### Using Helper Scripts
```bash
# Windows
run_tests.bat

# Mac/Linux
chmod +x run_tests.sh
./run_tests.sh
```

## 📋 Common Commands

```bash
# Run all tests
flutter test

# Run unit tests only
flutter test test/unit/

# Run specific file
flutter test test/unit/favorites_cubit_test.dart

# Run with coverage
flutter test --coverage

# Generate mocks
dart run build_runner build --delete-conflicting-outputs

# Clean generated files
dart run build_runner clean

# Full clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
```

## 📊 Test Statistics

| Component | Tests | Status |
|-----------|-------|--------|
| New Tests | 123 | ✅ |
| Existing Tests | 81 | ✅ |
| **Total** | **204** | ✅ |

## 📁 Test Files

### New Unit Tests
- `test/unit/favorites_cubit_test.dart` (18 tests)
- `test/unit/favorites_repository_test.dart` (20 tests)
- `test/unit/favorite_model_test.dart` (20 tests)
- `test/unit/breed_model_test.dart` (18 tests)
- `test/unit/favorites_state_test.dart` (22 tests)
- `test/unit/api_error_handler_test.dart` (25 tests)

### Existing Unit Tests
- `test/unit/home_cubit_test.dart` (22 tests)
- `test/unit/home_repository_test.dart` (11 tests)
- `test/unit/api_error_model_test.dart` (28 tests)
- `test/unit/cache_helper_test.dart` (15 tests)
- `test/unit/app_routes_test.dart` (5 tests)

## ⚠️ Before First Run

**IMPORTANT:** Generate mock files first!

```bash
dart run build_runner build --delete-conflicting-outputs
```

Without this, you'll see errors like:
- "Target of URI doesn't exist: 'xxx_test.mocks.dart'"
- "Undefined class 'MockXxx'"

## 🔧 Troubleshooting

### Mock files not generating?
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Tests failing?
1. Check mocks are generated
2. Run `flutter pub get`
3. Read error messages
4. Check `TESTING_SETUP_GUIDE.md`

### Build runner hanging?
1. Press Ctrl+C to cancel
2. Try: `flutter clean`
3. Try: `flutter pub get`
4. Try again

## 📚 Documentation

- `TEST_COMPLETION_SUMMARY.md` - Overview of all tests
- `TESTING_SETUP_GUIDE.md` - Detailed setup instructions
- `UNIT_TESTS_SUMMARY.md` - In-depth test information
- `test/README.md` - Main test documentation
- `test/unit/README_TESTS.md` - Unit test details

## ✅ Quick Verification

```bash
# 1. Generate mocks
dart run build_runner build --delete-conflicting-outputs

# 2. Run one test file to verify
flutter test test/unit/favorites_state_test.dart

# 3. If successful, run all
flutter test
```

Expected output: `+204: All tests passed!`

## 🎯 Test Coverage

Run with coverage:
```bash
flutter test --coverage
```

View coverage (requires lcov):
```bash
# Mac: brew install lcov
# Linux: sudo apt-get install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔥 Most Common Issues

1. **Mock files missing** → Run build_runner
2. **Dependencies not installed** → Run flutter pub get
3. **Build runner hangs** → Clean and retry
4. **Tests timeout** → Check for infinite loops

## 💡 Tips

- Run tests before committing code
- Keep coverage above 75%
- Use helper scripts for convenience
- Check documentation when stuck
- All tests should be independent
- Mock external dependencies

## 📞 Need Help?

1. Check this quick reference first
2. Read `TESTING_SETUP_GUIDE.md` for details
3. Check specific documentation files
4. Look at existing test examples

---

**Remember:** Always run `dart run build_runner build --delete-conflicting-outputs` before running tests for the first time!

