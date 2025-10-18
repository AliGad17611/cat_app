# Navigation Structure Update

## Overview
The app navigation has been restructured to use a main navigation container with a persistent bottom navigation bar across four main screens.

## New Navigation Structure

```
OnboardingView
    ↓
MainNavigationView (with Bottom Navigation Bar)
    ├─ Home Screen (index 0)
    ├─ Favorites Screen (index 1)
    ├─ Chat Screen (index 2) - Placeholder
    └─ Profile Screen (index 3) - Placeholder
```

## Key Changes

### 1. Main Navigation Container
**File:** `lib/features/main_navigation/presentation/views/main_navigation_view.dart`

A new container view that:
- Manages the bottom navigation bar state
- Uses `IndexedStack` to preserve state across tab switches
- Provides `MultiBlocProvider` for shared cubits (HomeCubit, FavoritesCubit)
- Contains all four main screens

### 2. Updated HomeView
**File:** `lib/features/home/presentation/views/home_view.dart`

Changes:
- Removed bottom navigation bar
- Removed MultiBlocProvider (now in MainNavigationView)
- Split into `HomeView` (wrapper) and `HomeViewContent` (content)
- Content is used within MainNavigationView

### 3. Updated FavoritesView
**File:** `lib/features/favorites/presentation/views/favorites_view.dart`

Changes:
- Removed BlocProvider (now in MainNavigationView)
- Split into `FavoritesView` (wrapper) and `FavoritesViewContent` (content)
- Content is used within MainNavigationView

### 4. Placeholder Screens

**Chat Screen:** Coming Soon placeholder with chat icon
**Profile Screen:** Coming Soon placeholder with profile icon

Both screens have:
- AppBar with title
- Centered icon and text
- Consistent styling with the app theme

### 5. Bottom Navigation Bar

Located in `MainNavigationView`, featuring:
- **Home** (index 0) - Cat breeds list
- **Favorites** (index 1) - Saved favorites
- **Chat** (index 2) - Placeholder
- **Profile** (index 3) - Placeholder

Design:
- Fixed height: 70h
- White background with shadow
- Selected state: Teal background with white icon
- Unselected state: Transparent background with grey icon
- Rounded containers (12r border radius)

### 6. Routes Added

**File:** `lib/core/routes/routes.dart`
```dart
static const String mainNavigation = '/main';
```

**File:** `lib/core/routes/app_routes.dart`
- Added route for `MainNavigationView`

### 7. Onboarding Navigation
**File:** `lib/features/onboarding/presentation/views/onboarding_view.dart`

Updated to navigate to `Routes.mainNavigation` instead of `Routes.home`

## Navigation Flow

1. **App Launch** → OnboardingView
2. **Get Started Button** → MainNavigationView (Home tab selected)
3. **Bottom Nav Taps** → Switch between tabs (state preserved)
4. **Back Button** → Exits app (MainNavigationView is the root after onboarding)

## Benefits

✅ **Persistent Bottom Bar:** Bottom navigation stays visible across main screens
✅ **State Preservation:** Using IndexedStack, each tab maintains its state
✅ **Shared State:** BlocProviders at MainNavigationView level allow favorites to work across Home and Favorites screens
✅ **Clean Structure:** Separated content from navigation concerns
✅ **Extensible:** Easy to replace Chat and Profile placeholders with real implementations

## Usage

### Navigating to Main Navigation
```dart
Navigator.pushReplacementNamed(context, Routes.mainNavigation);
```

### Bottom Navigation Auto-handled
No manual navigation needed - tapping bottom nav items automatically switches tabs using `setState` and `IndexedStack`.

## Future Enhancements

- Implement Chat feature (messages, chat list)
- Implement Profile feature (user info, settings)
- Add navigation guards (auth checks)
- Add tab-specific back button handling
- Add badge indicators for notifications

## Testing

To test the new navigation:

1. Launch app → See onboarding
2. Tap "Get Started" → Navigate to Home tab
3. Tap Favorites icon → Switch to Favorites tab
4. Tap Chat icon → See Chat placeholder
5. Tap Profile icon → See Profile placeholder
6. Tap Home icon → Return to Home tab
7. Verify favorites still work across Home and Favorites tabs

