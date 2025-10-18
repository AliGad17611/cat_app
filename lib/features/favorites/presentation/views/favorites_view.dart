import 'package:cat_app/core/helper/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:cat_app/features/favorites/presentation/widgets/favorite_card_widget.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: const FavoritesViewContent(),
    );
  }
}

class FavoritesViewContent extends StatelessWidget {
  const FavoritesViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Favorite Pets',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                verticalSpace(16),
                _buildCategoryTabs(),
              ],
            ),
          ),
          const Expanded(child: _FavoritesList()),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip('All', isSelected: true),
          horizontalSpace(8),
          _buildCategoryChip('Cats'),
          horizontalSpace(8),
          _buildCategoryChip('Dogs'),
          horizontalSpace(8),
          _buildCategoryChip('Birds'),
          horizontalSpace(8),
          _buildCategoryChip('Fish'),
          horizontalSpace(8),
          _buildCategoryChip('Reptiles'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.backgroundTealLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  const _FavoritesList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.status == FavoritesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == FavoritesStatus.failure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.errorIcon != null)
                    Icon(state.errorIcon, size: 64.sp, color: AppColors.red),
                  verticalSpace(24),
                  Text(
                    state.errorMessage ?? 'Failed to load favorites',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalSpace(24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoritesCubit>().loadFavorites(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                verticalSpace(16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpace(8),
                Text(
                  'Start adding your favorite cats!',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final favorite = state.favorites[index];
              return FavoriteCardWidget(favorite: favorite);
            },
          ),
        );
      },
    );
  }
}
