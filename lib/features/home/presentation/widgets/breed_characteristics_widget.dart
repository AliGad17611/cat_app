import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/presentation/widgets/characteristic_row_widget.dart';
import 'package:flutter/material.dart';

class BreedCharacteristicsWidget extends StatelessWidget {
  final BreedModel breed;

  const BreedCharacteristicsWidget({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Characteristics', style: AppTextStyles.font18W700Black),
        verticalSpace(12),
        if (breed.adaptability != null)
          CharacteristicRowWidget(
            label: 'Adaptability',
            value: breed.adaptability!,
          ),
        if (breed.affectionLevel != null)
          CharacteristicRowWidget(
            label: 'Affection Level',
            value: breed.affectionLevel!,
          ),
        if (breed.childFriendly != null)
          CharacteristicRowWidget(
            label: 'Child Friendly',
            value: breed.childFriendly!,
          ),
        if (breed.dogFriendly != null)
          CharacteristicRowWidget(
            label: 'Dog Friendly',
            value: breed.dogFriendly!,
          ),
        if (breed.energyLevel != null)
          CharacteristicRowWidget(
            label: 'Energy Level',
            value: breed.energyLevel!,
          ),
        if (breed.grooming != null)
          CharacteristicRowWidget(label: 'Grooming', value: breed.grooming!),
        if (breed.healthIssues != null)
          CharacteristicRowWidget(
            label: 'Health Issues',
            value: breed.healthIssues!,
          ),
        if (breed.intelligence != null)
          CharacteristicRowWidget(
            label: 'Intelligence',
            value: breed.intelligence!,
          ),
        if (breed.sheddingLevel != null)
          CharacteristicRowWidget(
            label: 'Shedding Level',
            value: breed.sheddingLevel!,
          ),
        if (breed.socialNeeds != null)
          CharacteristicRowWidget(
            label: 'Social Needs',
            value: breed.socialNeeds!,
          ),
        if (breed.strangerFriendly != null)
          CharacteristicRowWidget(
            label: 'Stranger Friendly',
            value: breed.strangerFriendly!,
          ),
        if (breed.vocalisation != null)
          CharacteristicRowWidget(
            label: 'Vocalisation',
            value: breed.vocalisation!,
          ),
      ],
    );
  }
}
