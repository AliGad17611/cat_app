import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class BreedAlternativeNamesWidget extends StatelessWidget {
  final String altNames;

  const BreedAlternativeNamesWidget({super.key, required this.altNames});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alternative Names', style: AppTextStyles.font18W700Black),
        verticalSpace(8),
        Text(altNames, style: AppTextStyles.font14W400TextSecondary),
      ],
    );
  }
}
