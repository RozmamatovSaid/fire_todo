import 'package:fire_todo/shared/widgets/global_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.icon, required this.onTap});
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: AppColors.darkGrey,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: BoxBorder.all(color: AppColors.grey500),
        ),
        child: GlobalImage(icon),
      ),
    );
  }
}
