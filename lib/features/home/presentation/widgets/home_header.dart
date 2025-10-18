import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_strings.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.homeHeaderTitle,
            style: AppTextStyles.font20W700Black,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              size: 24.sp,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}


