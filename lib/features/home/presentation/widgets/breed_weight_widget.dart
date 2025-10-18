import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:cat_app/features/home/data/models/weight_model.dart';
import 'package:flutter/material.dart';

class BreedWeightWidget extends StatelessWidget {
  final WeightModel weight;

  const BreedWeightWidget({super.key, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Weight', style: AppTextStyles.font18W700Black),
        verticalSpace(8),
        Text(
          'Imperial: ${weight.imperial} lbs',
          style: AppTextStyles.font14W400TextSecondary,
        ),
        verticalSpace(4),
        Text(
          'Metric: ${weight.metric} kg',
          style: AppTextStyles.font14W400TextSecondary,
        ),
      ],
    );
  }
}
