import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../shared/widgets/global_text.dart';

class ToDoBadge extends StatelessWidget {
  const ToDoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 14.74 * 3.1416 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.gold,
          border: BoxBorder.all(color: AppColors.background),
          borderRadius: BorderRadius.circular(23),
        ),
        child: GlobalText(
          "to do",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.recoleta,
          color: AppColors.background,
        ),
      ),
    );
  }
}
