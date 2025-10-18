import 'package:cat_app/core/helper/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/features/home/presentation/widgets/home_header.dart';
import 'package:cat_app/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/category_list_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/pet_card_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/bottom_nav_bar_widget.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/di/injection_container.dart';
import 'package:cat_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:cat_app/features/home/presentation/cubit/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadBreeds(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              verticalSpace(16),
              const HomeHeader(),
              verticalSpace(20),
              const SearchBarWidget(),
              verticalSpace(24),
              const CategoryListWidget(),
              verticalSpace(20),
              const Expanded(child: _BreedsList()),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}

class _BreedsList extends StatefulWidget {
  const _BreedsList();

  @override
  State<_BreedsList> createState() => _BreedsListState();
}

class _BreedsListState extends State<_BreedsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeCubit>().loadMoreBreeds();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeStatus.failure) {
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
                    state.errorMessage ?? 'Failed to load breeds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalSpace(24),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().refreshBreeds(),
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

        if (state.breeds.isEmpty) {
          return const Center(child: Text('No breeds available'));
        }

        return RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().refreshBreeds(),
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount:
                state.breeds.length +
                (state.status == HomeStatus.loadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.breeds.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final breed = state.breeds[index];
              return PetCardWidget(breed: breed);
            },
          ),
        );
      },
    );
  }
}
