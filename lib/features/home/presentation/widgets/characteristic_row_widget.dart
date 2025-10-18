import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CharacteristicRowWidget extends StatelessWidget {
  final String label;
  final int value;

  const CharacteristicRowWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTextStyles.font14W500Black),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: value / 5,
                        child: Container(
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpace(8),
                Text('$value/5', style: AppTextStyles.font12W400TextSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
