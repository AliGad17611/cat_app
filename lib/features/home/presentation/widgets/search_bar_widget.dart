import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:cat_app/core/utils/app_strings.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Icon(Icons.search, color: AppColors.grey, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppStrings.searchHint,
                        hintStyle: AppTextStyles.font14W400Grey,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.tune, color: AppColors.black, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
