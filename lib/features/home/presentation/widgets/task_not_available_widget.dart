import 'package:fire_todo/shared/extensions/gap.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/global_image.dart';
import '../../../../shared/widgets/global_text.dart';

class TaskNotAvailableWidget extends StatelessWidget {
  const TaskNotAvailableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GlobalImage(
            AppAssets.emptyTasks,
            width: 260,
            height: 194,
            fit: BoxFit.cover,
          ),
          24.g,
          GlobalText(
            AppStrings.taskBoxEmpty,
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          8.g,
          GlobalText(
            AppStrings.taskCreateInfo,
            color: AppColors.grey300,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            padding: EdgeInsetsGeometry.symmetric(horizontal: 44),
          ),
        ],
      ),
    );
  }
}
