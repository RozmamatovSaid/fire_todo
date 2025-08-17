import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/global_image.dart';

// Clickable SearchTextField - SearchBar ochish uchun
class ClickableSearchTextField extends StatelessWidget {
  final VoidCallback onTap;

  const ClickableSearchTextField({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: SizedBox(
          height: 55,
          child: TextField(
            cursorColor: AppColors.gold,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.tryToFindTask.tr(),
              hintStyle: TextStyle(
                color: AppColors.grey400,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(39),
                borderSide: BorderSide(color: AppColors.grey500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(39),
                borderSide: BorderSide(color: AppColors.gold),
              ),
              focusColor: AppColors.gold,
              fillColor: AppColors.background,
              prefixIcon: GlobalImage(AppAssets.searchNormal),
            ),
          ),
        ),
      ),
    );
  }
}
