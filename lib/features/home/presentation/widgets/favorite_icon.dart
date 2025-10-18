import 'package:cat_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteIcon extends StatefulWidget {
  final bool isFavorite;
  const FavoriteIcon({super.key, required this.isFavorite});
  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
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
  }
}
