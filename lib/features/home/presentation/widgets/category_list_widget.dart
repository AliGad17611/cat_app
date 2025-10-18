import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_strings.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/features/home/presentation/widgets/category_chip_widget.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({super.key});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  int selectedIndex = 0;
  final List<String> categories = ['All', 'Cats', 'Dogs', 'Birds', 'Fish', 'Rept'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            AppStrings.categoryListTitle,
            style: AppTextStyles.font16W700Black,
          ),
        ),
        verticalSpace(16),
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              return CategoryChipWidget(
                label: categories[index],
                isSelected: selectedIndex == index,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
