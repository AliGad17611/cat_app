# Error Handling Update

## Summary
Updated the error handling architecture to move try-catch logic from Cubit to Repository, utilizing the existing API error handler system.

## Changes Made

### 1. Repository Layer (`home_repository.dart`)
**Before:**
```dart
try {
  final breeds = await _apiService.getBreeds(limit, page);
  return breeds;
} on DioException {
  rethrow;
} catch (e) {
  rethrow;
}
```

**After:**
```dart
try {
  final breeds = await _apiService.getBreeds(limit, page);
  return breeds;
} catch (e) {
  final apiError = ApiErrorHandler.handle(e);
  throw apiError;
}
```

**Key Changes:**
- Now catches **any** exception (not just `DioException`)
- Uses `ApiErrorHandler.handle(e)` to process errors
- Throws `ApiErrorModel` which contains:
  - `message`: User-friendly error message
  - `statusCode`: HTTP status code
  - `errors`: List of error details
  - `icon`: Appropriate icon for the error type

### 2. Cubit Layer (`home_cubit.dart`)
**Before:**
```dart
// No try-catch - errors would crash the app
```

**After:**
```dart
try {
  // ... loading logic ...
  final breeds = await _repository.getBreeds(page: page);
  // ... state updates ...
} on ApiErrorModel catch (e) {
  emit(
    state.copyWith(status: HomeStatus.failure, errorMessage: e.message),
  );
} catch (e) {
  emit(
    state.copyWith(
      status: HomeStatus.failure,
      errorMessage: 'An unexpected error occurred',
    ),
  );
}
```

**Key Changes:**
- Added try-catch block around repository call
- Catches `ApiErrorModel` specifically from repository
- Emits failure state with the error message
- Has fallback for unexpected errors

### 3. View Layer (`home_view.dart`)
**No Changes Required:**
- View remains clean and simple
- Only displays error states from Cubit
- No error handling logic in UI

## Error Flow

```
API Call Error
    ↓
Repository catches it
    ↓
ApiErrorHandler.handle(e) processes it
    ↓
Returns ApiErrorModel
    ↓
Repository throws ApiErrorModel
    ↓
Cubit catches ApiErrorModel
    ↓
Cubit emits failure state with message
    ↓
View displays error to user
```

## Benefits

1. **Centralized Error Handling**: All API errors go through `ApiErrorHandler`
2. **Clean Separation**: 
   - Repository: Handles API errors
   - Cubit: Handles business logic errors
   - View: Displays errors
3. **Consistent Error Messages**: Uses your existing error handler for consistent UX
4. **Type Safety**: Uses `ApiErrorModel` instead of generic exceptions
5. **Better Testing**: Easy to mock `ApiErrorModel` in tests

## Error Types Handled by ApiErrorHandler

- **Connection errors** (no internet)
- **Timeout errors** (connection, send, receive)
- **HTTP errors** (400, 401, 403, 404, 409, 422, 500, etc.)
- **Certificate errors**
- **Cancelled requests**
- **Unknown errors**

Each error type gets:
- Appropriate user-friendly message
- Correct status code
- Relevant icon
- Detailed error list

## Example Error Messages

- **No Internet**: "No internet connection. Please check your Wi-Fi or mobile data."
- **Timeout**: "The connection took too long. Try checking your internet or try again later."
- **404**: "Not found" with search_off icon
- **500**: "Server error, please try again later" with error icon
- **Default**: "Something went wrong. Please check your connection and try again."

## Testing Scenarios

1. **No Internet**: Turn off WiFi → Should show connection error
2. **Timeout**: Slow connection → Should show timeout message  
3. **Server Error**: API down → Should show server error
4. **Success → Error**: Load data, then lose connection → Shows error state
5. **Retry**: Click retry button → Should reload data
6. **Pull to Refresh**: Pull down on error → Should retry

