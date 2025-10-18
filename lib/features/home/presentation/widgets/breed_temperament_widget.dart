import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BreedTemperamentWidget extends StatelessWidget {
  final String temperament;

  const BreedTemperamentWidget({super.key, required this.temperament});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Temperament', style: AppTextStyles.font18W700Black),
        verticalSpace(8),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: temperament
              .split(',')
              .map(
                (trait) => Chip(
                  label: Text(
                    trait.trim(),
                    style: AppTextStyles.font12W400Primary,
                  ),
                  backgroundColor: AppColors.backgroundTealLight,
                  side: BorderSide.none,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
