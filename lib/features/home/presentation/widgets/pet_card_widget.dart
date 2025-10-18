import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/features/home/presentation/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';

class PetCardWidget extends StatelessWidget {
  final String name;
  final String gender;
  final String age;
  final String distance;
  final String imageUrl;
  final bool isFavorite;
  const PetCardWidget({
    super.key,
    required this.name,
    required this.gender,
    required this.age,
    required this.distance,
    required this.imageUrl,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pet Image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.backgroundTealLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.pets,
                    color: AppColors.primary,
                    size: 40.sp,
                  );
                },
              ),
            ),
          ),
          horizontalSpace(16),
          // Pet Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.font16W700Black),
                verticalSpace(4),
                Text(gender, style: AppTextStyles.font12W400TextSecondary),
                verticalSpace(2),
                Text(age, style: AppTextStyles.font12W400TextSecondary),
                verticalSpace(6),
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.red, size: 14.sp),
                    horizontalSpace(4),
                    Text(
                      distance,
                      style: AppTextStyles.font11W400TextSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Favorite Icon
          FavoriteIcon(isFavorite: isFavorite),
        ],
      ),
    );
  }
}
