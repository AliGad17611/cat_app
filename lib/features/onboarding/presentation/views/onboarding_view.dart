import 'package:cat_app/core/routes/routes.dart';
import 'package:cat_app/core/utils/app_assets.dart';
import 'package:cat_app/core/utils/app_strings.dart';
import 'package:cat_app/core/utils/app_text_styles.dart';
import 'package:cat_app/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.onboardingImage),
          SizedBox(height: 61.h),
          Text(
            AppStrings.onboardingTitle,
            style: AppTextStyles.font32W700Black,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.onboardingDescription,
            style: AppTextStyles.font16W400Grey,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 61.h),
          PrimaryButton(
            text: AppStrings.getStartedButton,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.home);
            },
            icon: Icons.pets,
          ),
        ],
      ),
    );
  }
}
