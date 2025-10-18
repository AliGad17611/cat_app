@echo off
REM Cat App Test Runner Script
REM This script generates mocks and runs all tests

echo ==========================================
echo Cat App Test Runner
echo ==========================================
echo.

REM Step 1: Generate mocks
echo Step 1: Generating mock files...
echo Running: dart run build_runner build --delete-conflicting-outputs
call dart run build_runner build --delete-conflicting-outputs

if %ERRORLEVEL% NEQ 0 (
    echo [X] Failed to generate mock files
    exit /b 1
)

echo [OK] Mock files generated successfully
echo.

REM Step 2: Run all tests
echo Step 2: Running all tests...
echo Running: flutter test
call flutter test

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [X] Some tests failed
    exit /b 1
)

echo.
echo [OK] All tests passed!
echo.
echo ==========================================
echo Test run completed successfully!
echo ==========================================
pause

