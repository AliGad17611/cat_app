import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class BreedDescriptionWidget extends StatelessWidget {
  final String description;

  const BreedDescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: AppTextStyles.font18W700Black),
        verticalSpace(8),
        Text(description, style: AppTextStyles.font14W400TextSecondary),
      ],
    );
  }
}
