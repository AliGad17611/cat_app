# Cat Breeds API Pagination Implementation

## Overview
This document describes the implementation of pagination for the Cat Breeds API in the cat_app project.

## API Details
- **Base URL**: `https://api.thecatapi.com/v1/`
- **Endpoint**: `breeds`
- **Query Parameters**: 
  - `limit`: Number of items per page (default: 20)
  - `page`: Page number (starts at 0)

## Architecture

### Data Layer
The data layer follows a clean architecture pattern without a domain layer.

#### Models
1. **WeightModel** (`lib/features/home/data/models/weight_model.dart`)
   - Properties: `imperial`, `metric`
   - JSON serialization with `json_annotation`

2. **BreedModel** (`lib/features/home/data/models/breed_model.dart`)
   - Complete mapping of all API fields
   - Includes helper method `imageUrl` to construct image URLs from `reference_image_id`
   - All snake_case API fields mapped to camelCase Dart properties

#### Data Sources
**HomeApiService** (`lib/features/home/data/datasources/home_api_service.dart`)
- Built with Retrofit
- Method: `getBreeds(limit, page)` returns `Future<List<BreedModel>>`

#### Repositories
**HomeRepository** (`lib/features/home/data/repositories/home_repository.dart`)
- Handles API calls through `HomeApiService`
- Error handling for `DioException`
- Method: `getBreeds({page, limit})`

### Presentation Layer

#### State Management
**HomeCubit** (`lib/features/home/presentation/cubit/home_cubit.dart`)
- Manages breed data and pagination state
- States: `initial`, `loading`, `loadingMore`, `success`, `failure`, `reachedEnd`
- Methods:
  - `loadBreeds({isRefresh})`: Loads breeds (initial or next page)
  - `refreshBreeds()`: Refreshes from page 0
  - `loadMoreBreeds()`: Loads next page

**HomeState** (`lib/features/home/presentation/cubit/home_state.dart`)
- Properties:
  - `status`: Current loading status
  - `breeds`: List of loaded breeds
  - `currentPage`: Current page number
  - `errorMessage`: Error message if any
  - `hasReachedEnd`: Whether all data has been loaded

#### UI Components
1. **HomeView** (`lib/features/home/presentation/views/home_view.dart`)
   - Provides `HomeCubit` via BlocProvider
   - Initializes data loading on mount
   - Contains `_BreedsList` widget

2. **_BreedsList** (StatefulWidget in HomeView)
   - Implements scroll-based pagination
   - Loads more when scrolled to 90% of content
   - Shows loading indicator while loading more
   - Implements pull-to-refresh
   - Error state with retry button
   - Empty state handling

3. **PetCardWidget** (`lib/features/home/presentation/widgets/pet_card_widget.dart`)
   - Updated to accept `BreedModel` instead of individual properties
   - Displays:
     - Breed image (from API)
     - Breed name
     - Origin
     - Life span
     - Temperament (first 2 traits)
   - Network image loading with placeholder

## Dependency Injection
**injection_container.dart** (`lib/core/di/injection_container.dart`)
- Registered services:
  - `HomeCubit` (Factory)
  - `HomeRepository` (Singleton)
  - `HomeApiService` (Singleton)
  - `Dio` instance (Singleton)

## Dependencies Added
```yaml
dependencies:
  json_annotation: ^4.9.0

dev_dependencies:
  json_serializable: ^6.8.0
  retrofit_generator: ^9.2.1
```

## Pagination Logic
1. Initial load: Fetches page 0 with 20 items
2. Scroll detection: When user scrolls to 90% of content, loads next page
3. Loading states:
   - First load: Shows centered loading indicator
   - Subsequent loads: Shows loading indicator at bottom of list
4. End detection: When API returns empty list, marks `hasReachedEnd = true`
5. Refresh: Pull-to-refresh resets to page 0 and clears existing data

## Features Implemented
✅ Pagination with dynamic loading
✅ Pull-to-refresh
✅ Loading states (initial, loading more)
✅ Error handling with retry
✅ End of list detection
✅ Network image loading with placeholders
✅ JSON serialization
✅ Retrofit API service
✅ Cubit state management
✅ Clean architecture (Data + Presentation layers)

## How to Test
1. Run the app: `flutter run`
2. Scroll down to trigger pagination
3. Pull down to refresh
4. Observe loading indicators and data updates

## Configuration
To modify pagination settings, edit:
- `lib/core/constants/pagination_constants.dart`
  - `pageSize`: Number of items per page (default: 20)

