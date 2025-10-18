@echo off
REM Integration Test Runner for Windows
REM Run all integration tests or specific test files

echo ========================================
echo Cat App Integration Test Runner
echo ========================================
echo.

REM Check if a specific test file is provided
if "%1"=="" (
    echo Running all integration tests...
    echo.
    
    echo Running app_test.dart...
    call flutter test integration_test/app_test.dart
    
    echo.
    echo Running onboarding_integration_test.dart...
    call flutter test integration_test/onboarding_integration_test.dart
    
    echo.
    echo Running home_integration_test.dart...
    call flutter test integration_test/home_integration_test.dart
    
    echo.
    echo Running favorites_integration_test.dart...
    call flutter test integration_test/favorites_integration_test.dart
    
    echo.
    echo Running breed_details_integration_test.dart...
    call flutter test integration_test/breed_details_integration_test.dart
    
) else (
    echo Running specific test: %1
    echo.
    call flutter test integration_test/%1
)

echo.
echo ========================================
echo Integration tests completed!
echo ========================================
pause

