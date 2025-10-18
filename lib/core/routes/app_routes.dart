import 'package:cat_app/features/home/presentation/views/home_view.dart';
import 'package:cat_app/features/home/presentation/views/breed_details_view.dart';
import 'package:cat_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:cat_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:cat_app/features/main_navigation/presentation/views/main_navigation_view.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/core/routes/routes.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';

class AppRoutes {
  const AppRoutes();
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.mainNavigation:
        return MaterialPageRoute(builder: (_) => const MainNavigationView());
      case Routes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());
      case Routes.breedDetails:
        final breed = settings.arguments as BreedModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<FavoritesCubit>(),
            child: BreedDetailsView(breed: breed),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
