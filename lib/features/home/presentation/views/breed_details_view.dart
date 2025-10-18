import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/presentation/widgets/favorite_icon.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_header_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_description_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_temperament_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_weight_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_characteristics_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_alternative_names_widget.dart';
import 'package:cat_app/features/home/presentation/widgets/breed_links_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/core/utils/app_colors.dart';

class BreedDetailsView extends StatelessWidget {
  final BreedModel breed;

  const BreedDetailsView({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(slivers: [_buildAppBar(), _buildContent()]),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        if (breed.referenceImageId != null)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: FavoriteIcon(imageId: breed.referenceImageId!),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(background: _buildHeaderImage()),
    );
  }

  Widget _buildHeaderImage() {
    return breed.imageUrl != null
        ? Image.network(
            breed.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderImage();
            },
          )
        : _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.backgroundTealLight,
      child: Icon(Icons.pets, color: AppColors.primary, size: 100.sp),
    );
  }

  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreedHeaderWidget(
              name: breed.name,
              origin: breed.origin,
              lifeSpan: breed.lifeSpan,
            ),
            verticalSpace(20),
            BreedDescriptionWidget(description: breed.description),
            verticalSpace(20),
            if (breed.temperament != null) ...[
              BreedTemperamentWidget(temperament: breed.temperament!),
              verticalSpace(20),
            ],
            BreedWeightWidget(weight: breed.weight),
            verticalSpace(20),
            BreedCharacteristicsWidget(breed: breed),
            verticalSpace(20),
            if (breed.altNames != null) ...[
              BreedAlternativeNamesWidget(altNames: breed.altNames!),
              verticalSpace(20),
            ],
            BreedLinksWidget(
              wikipediaUrl: breed.wikipediaUrl,
              cfaUrl: breed.cfaUrl,
              vetstreetUrl: breed.vetstreetUrl,
            ),
            verticalSpace(40),
          ],
        ),
      ),
    );
  }
}
