import 'package:cat_app/core/helper/spacing.dart';
import 'package:cat_app/core/utils/app_colors.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BreedLinksWidget extends StatelessWidget {
  final String? wikipediaUrl;
  final String? cfaUrl;
  final String? vetstreetUrl;

  const BreedLinksWidget({
    super.key,
    this.wikipediaUrl,
    this.cfaUrl,
    this.vetstreetUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (wikipediaUrl == null && cfaUrl == null && vetstreetUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learn More', style: AppTextStyles.font18W700Black),
        verticalSpace(8),
        if (wikipediaUrl != null)
          _LinkButton(label: 'Wikipedia', icon: Icons.open_in_new),
        if (cfaUrl != null) _LinkButton(label: 'CFA', icon: Icons.open_in_new),
        if (vetstreetUrl != null)
          _LinkButton(label: 'Vetstreet', icon: Icons.open_in_new),
      ],
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _LinkButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundTealLight,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20.sp),
            horizontalSpace(12),
            Text(label, style: AppTextStyles.font14W500Primary),
          ],
        ),
      ),
    );
  }
}
