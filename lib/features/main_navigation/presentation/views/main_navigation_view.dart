import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/di/injection_container.dart';
import 'package:cat_app/features/home/presentation/views/home_view.dart';
import 'package:cat_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/home/presentation/cubit/home_cubit.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;

  // Create placeholder screens for Chat and Profile
  final List<Widget> _screens = [
    const HomeViewContent(), // Home
    const FavoritesViewContent(), // Favorites
    const ChatView(), // Chat placeholder
    const ProfileView(), // Profile placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HomeCubit>()..loadBreeds()),
        BlocProvider(
          create: (context) => getIt<FavoritesCubit>()..loadFavorites(),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.favorite_border, 'Favorites', 1),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 2),
          _buildNavItem(Icons.person_outline, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.white : AppColors.grey,
          size: 24.sp,
        ),
      ),
    );
  }
}

// Placeholder screens
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Chat',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'Chat Feature',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80.sp, color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              'Profile Feature',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
