import 'package:cat_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';

class FavoriteIcon extends StatelessWidget {
  final String imageId;
  final String? subId;

  const FavoriteIcon({super.key, required this.imageId, this.subId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(imageId);

        return GestureDetector(
          onTap: () {
            context.read<FavoritesCubit>().toggleFavorite(
              imageId: imageId,
              subId: subId,
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
        );
      },
    );
  }
}
