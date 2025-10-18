@echo off
REM Cat App Test Runner Script for Windows
REM This script provides convenient commands to run tests

setlocal

echo Cat App Test Runner
echo =====================
echo.

if "%1"=="" goto usage
if "%1"=="all" goto all
if "%1"=="unit" goto unit
if "%1"=="widget" goto widget
if "%1"=="coverage" goto coverage
if "%1"=="clean" goto clean
if "%1"=="watch" goto watch
goto usage

:all
echo Running all tests...
flutter test
echo.
echo All tests completed!
goto end

:unit
echo Running unit tests...
flutter test test/unit/
echo.
echo Unit tests completed!
goto end

:widget
echo Running widget tests...
flutter test test/widget/
echo.
echo Widget tests completed!
goto end

:coverage
echo Running tests with coverage...
flutter test --coverage
echo.
echo Coverage report generated in coverage/lcov.info
goto end

:clean
echo Cleaning test artifacts...
if exist coverage rmdir /s /q coverage
flutter clean
flutter pub get
echo.
echo Clean completed!
goto end

:watch
echo Running tests in watch mode...
flutter test --watch
goto end

:usage
echo Usage: %0 {all^|unit^|widget^|coverage^|clean^|watch}
echo.
echo Commands:
echo   all      - Run all tests
echo   unit     - Run only unit tests
echo   widget   - Run only widget tests
echo   coverage - Run tests with coverage
echo   clean    - Clean test artifacts
echo   watch    - Run tests in watch mode
echo.
echo Example: %0 all
exit /b 1

:end
endlocal

