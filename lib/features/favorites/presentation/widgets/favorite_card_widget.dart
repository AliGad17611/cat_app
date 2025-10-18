import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';

class FavoriteCardWidget extends StatelessWidget {
  final FavoriteModel favorite;

  const FavoriteCardWidget({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundTealLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cat Image with Favorite Icon
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundTealLight,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: favorite.image != null
                        ? Image.network(
                            favorite.image!.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.pets,
                                  color: AppColors.primary,
                                  size: 40.sp,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.pets,
                              color: AppColors.primary,
                              size: 40.sp,
                            ),
                          ),
                  ),
                ),
                // Favorite Icon in top right
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      context.read<FavoritesCubit>().removeFavorite(
                        imageId: favorite.imageId,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Cat Info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cat ${favorite.id}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14.sp, color: AppColors.red),
                    horizontalSpace(4),
                    Expanded(
                      child: Text(
                        _formatDistance(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDistance() {
    try {
      final date = DateTime.parse(favorite.createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} km away';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} km away';
      } else {
        return '1 km away';
      }
    } catch (e) {
      return '2 km away';
    }
  }
}
