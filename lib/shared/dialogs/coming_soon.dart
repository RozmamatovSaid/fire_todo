import 'package:flutter/material.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/constants/app_strings.dart';

Future<void> showComingSoonDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.grey700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.hourglass_empty_rounded,
                size: 60,
                color: AppColors.purple,
              ),
              const SizedBox(height: 20),
              const GlobalText(
                AppStrings.comingSoon,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
              const SizedBox(height: 8),
              const GlobalText(
                AppStrings.comingSoonDesc,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey300,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const GlobalText(
                  AppStrings.close,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
