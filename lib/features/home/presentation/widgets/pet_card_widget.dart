import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/features/home/presentation/widgets/favorite_icon.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/presentation/views/breed_details_view.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';

class PetCardWidget extends StatelessWidget {
  final BreedModel breed;

  const PetCardWidget({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final favoritesCubit = context.read<FavoritesCubit>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: favoritesCubit,
              child: BreedDetailsView(breed: breed),
            ),
          ),
        );
      },
      child: Container(
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
                child: breed.imageUrl != null
                    ? Image.network(
                        breed.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pets,
                            color: AppColors.primary,
                            size: 40.sp,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Icon(Icons.pets, color: AppColors.primary, size: 40.sp),
              ),
            ),
            horizontalSpace(16),
            // Pet Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(breed.name, style: AppTextStyles.font16W700Black),
                  verticalSpace(4),
                  if (breed.origin != null)
                    Text(
                      'Origin: ${breed.origin}',
                      style: AppTextStyles.font12W400TextSecondary,
                    ),
                  verticalSpace(2),
                  if (breed.lifeSpan != null)
                    Text(
                      'Life span: ${breed.lifeSpan} years',
                      style: AppTextStyles.font12W400TextSecondary,
                    ),
                  verticalSpace(6),
                  if (breed.temperament != null)
                    Row(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt,
                          color: AppColors.primary,
                          size: 14.sp,
                        ),
                        horizontalSpace(4),
                        Expanded(
                          child: Text(
                            breed.temperament!.split(',').take(2).join(','),
                            style: AppTextStyles.font11W400TextSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // Favorite Icon
            if (breed.referenceImageId != null)
              FavoriteIcon(imageId: breed.referenceImageId!),
          ],
        ),
      ),
    );
  }
}
