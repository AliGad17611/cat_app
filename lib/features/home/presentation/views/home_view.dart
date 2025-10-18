import 'package:cat_app/core/helper/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/features/home/presentation/widgets/home_header.dart';
import 'package:cat_app/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/category_list_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/pet_card_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/bottom_nav_bar_widget.dart';
import 'package:cat_app/core/utils/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: const [
                  PetCardWidget(
                    name: 'Joli',
                    gender: 'Female',
                    age: '5 Months Old',
                    distance: '1.6 km away',
                    imageUrl: 'assets/images/cat1.png',
                    isFavorite: false,
                  ),
                  PetCardWidget(
                    name: 'Tom',
                    gender: 'Male',
                    age: '1 year Old',
                    distance: '2.7 km away',
                    imageUrl: 'assets/images/dog1.png',
                    isFavorite: false,
                  ),
                  PetCardWidget(
                    name: 'Oliver',
                    gender: 'Male & female',
                    age: '3 Months Old',
                    distance: '2 km away',
                    imageUrl: 'assets/images/bird1.png',
                    isFavorite: false,
                  ),
                  PetCardWidget(
                    name: 'Shelly',
                    gender: 'Female',
                    age: '1.5 year Old',
                    distance: '3 km away',
                    imageUrl: 'assets/images/dog2.png',
                    isFavorite: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
