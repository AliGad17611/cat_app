# Favorites Feature Implementation

## Overview
This document describes the implementation of the favorites feature for the Cat App, which allows users to favorite cat images using TheCatAPI's favorites endpoints.

## Feature Structure

The favorites feature is organized as a separate feature module under `lib/features/favorites/` following clean architecture principles:

```
lib/features/favorites/
├── data/
│   ├── datasources/
│   │   ├── favorites_api_service.dart
│   │   └── favorites_api_service.g.dart
│   ├── models/
│   │   ├── favorite_model.dart
│   │   └── favorite_model.g.dart
│   └── repositories/
│       └── favorites_repository.dart
└── presentation/
    ├── cubit/
    │   ├── favorites_cubit.dart
    │   └── favorites_state.dart
    ├── views/
    │   └── favorites_view.dart
    └── widgets/
        └── favorite_card_widget.dart
```

## API Integration

### Endpoints Used

1. **POST /favourites** - Create a favorite
   - Body: `{ "image_id": "string", "sub_id": "string" }`
   - Returns: `{ "id": number, "message": "string" }`

2. **GET /favourites** - Get all favorites
   - Query params: `attach_image`, `sub_id`, `page`, `limit`, `order`
   - Returns: Array of favorite objects with optional image data

3. **DELETE /favourites/{favouriteId}** - Delete a favorite
   - Path param: `favouriteId`
   - Returns: Success status

### API Configuration

The API key is configured in `lib/core/constants/api_constants.dart`:
```dart
static const String apiKey = 'live_qQB3pe6S21hmdPSlLKMrBxTfWpJNdSXCLDB296l58lc9gTjcZwHmVnWKNpS9ZNbH';
```

The API key is automatically included in all requests via the `DioFactory` headers configuration.

## Data Models

### FavoriteModel
Represents a favorite returned from the API:
- `id`: Unique favorite ID
- `imageId`: The cat image ID
- `subId`: Optional user identifier
- `createdAt`: Timestamp when favorited
- `image`: Optional image data (url, id)

### CreateFavoriteRequest
Request payload for creating a favorite:
- `imageId`: Required cat image ID
- `subId`: Optional user identifier

### CreateFavoriteResponse
Response from creating a favorite:
- `id`: The new favorite's ID
- `message`: Success message

## State Management

### FavoritesCubit
Manages the favorites feature state with the following methods:

- **loadFavorites()** - Fetches all favorites from the API
- **addFavorite(imageId, subId)** - Adds a new favorite (optimistic update)
- **removeFavorite(imageId, subId)** - Removes a favorite (optimistic update)
- **toggleFavorite(imageId, subId)** - Toggles favorite status

### FavoritesState
Contains:
- `status`: Loading state (initial, loading, success, failure)
- `favorites`: List of favorite objects
- `favoriteImageIds`: Set of favorited image IDs for quick lookup
- `errorMessage` & `errorIcon`: Error display data

Helper methods:
- `isFavorite(imageId)`: Check if an image is favorited
- `getFavoriteId(imageId)`: Get the favorite ID for an image

## UI Components

### FavoriteIcon Widget
Location: `lib/features/home/presentation/widgets/favorite_icon.dart`

An interactive favorite button that:
- Shows filled heart icon when favorited (red color)
- Shows outlined heart icon when not favorited (primary color)
- Toggles favorite status on tap
- Automatically updates based on FavoritesCubit state

Usage:
```dart
FavoriteIcon(
  imageId: breed.referenceImageId!,
  subId: 'optional-user-id',
)
```

### FavoritesView
Location: `lib/features/favorites/presentation/views/favorites_view.dart`

A full-screen view displaying:
- App bar with "My Favorites" title
- Loading indicator while fetching
- Error state with retry button
- Empty state with helpful message
- Grid/List of favorite cat images
- Pull-to-refresh functionality

### FavoriteCardWidget
Location: `lib/features/favorites/presentation/widgets/favorite_card_widget.dart`

Displays individual favorite items with:
- Cat image thumbnail
- "Cat Image" title
- Time since favorited (e.g., "2h ago")
- Remove button (filled heart icon)

## Integration Points

### Home View
The `HomeView` now provides both `HomeCubit` and `FavoritesCubit` using `MultiBlocProvider`:
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => getIt<HomeCubit>()..loadBreeds()),
    BlocProvider(create: (context) => getIt<FavoritesCubit>()..loadFavorites()),
  ],
  child: Scaffold(...),
)
```

### Pet Card Widget
Updated to include the `FavoriteIcon` for each breed:
```dart
if (breed.referenceImageId != null)
  FavoriteIcon(imageId: breed.referenceImageId!)
```

### Bottom Navigation Bar
The favorites icon (index 1) navigates to the favorites view:
```dart
if (index == 1) {
  Navigator.pushNamed(context, Routes.favorites);
}
```

### Routing
Added new route in `lib/core/routes/routes.dart`:
```dart
static const String favorites = '/favorites';
```

## Dependency Injection

Registered in `lib/core/di/injection_container.dart`:
```dart
// Cubit
getIt.registerFactory(() => FavoritesCubit(getIt()));

// Repository
getIt.registerLazySingleton(() => FavoritesRepository(getIt()));

// Data Sources
getIt.registerLazySingleton(() => FavoritesApiService(getIt()));
```

## Features Implemented

✅ Create favorites by tapping heart icon on breed cards
✅ View all favorites in dedicated favorites screen
✅ Delete favorites with optimistic UI updates
✅ Toggle favorite status with instant feedback
✅ Display favorite images with metadata
✅ Error handling with user-friendly messages
✅ Loading states and empty states
✅ Pull-to-refresh functionality
✅ Navigation via bottom navigation bar
✅ API key authentication
✅ Clean architecture with separation of concerns

## Optimistic Updates

The favorites feature uses optimistic updates for better UX:

1. When adding a favorite, the UI immediately shows the favorited state
2. If the API call fails, the state reverts with an error message
3. When removing a favorite, the item is immediately removed from the list
4. If the API call fails, the favorites list is reloaded from the server

This provides instant feedback to users while maintaining data consistency.

## Testing the Feature

1. **Add a favorite**: Tap the heart icon on any cat breed card in the home view
2. **View favorites**: Tap the favorites icon (second icon) in the bottom navigation bar
3. **Remove a favorite**: In the favorites view, tap the filled heart icon on any favorite
4. **Refresh favorites**: Pull down on the favorites list to refresh

## Error Handling

All API calls are wrapped in try-catch blocks with proper error handling:
- Network errors show appropriate error messages
- Failed operations revert optimistic updates
- Users can retry failed operations
- Error states include helpful icons and messages

## Notes

- The `subId` parameter is optional and can be used to associate favorites with specific users
- Favorites are stored server-side via TheCatAPI
- The feature uses Retrofit for type-safe API calls
- JSON serialization is handled by json_serializable
- State management uses flutter_bloc and Cubit pattern
- The API key is configured and automatically included in all requests

