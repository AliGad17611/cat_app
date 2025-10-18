import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BreedHeaderWidget extends StatelessWidget {
  final String name;
  final String? origin;
  final String? lifeSpan;

  const BreedHeaderWidget({
    super.key,
    required this.name,
    this.origin,
    this.lifeSpan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: AppTextStyles.font24W700Black),
        verticalSpace(8),
        if (origin != null || lifeSpan != null)
          Row(
            children: [
              if (origin != null) ...[
                Icon(Icons.location_on, color: AppColors.primary, size: 16.sp),
                horizontalSpace(4),
                Text(origin!, style: AppTextStyles.font14W400TextSecondary),
              ],
              if (origin != null && lifeSpan != null) horizontalSpace(16),
              if (lifeSpan != null) ...[
                Icon(Icons.access_time, color: AppColors.primary, size: 16.sp),
                horizontalSpace(4),
                Text(
                  '$lifeSpan years',
                  style: AppTextStyles.font14W400TextSecondary,
                ),
              ],
            ],
          ),
      ],
    );
  }
}
