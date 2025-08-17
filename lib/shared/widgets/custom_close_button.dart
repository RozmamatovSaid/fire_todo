import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.grey700,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 4),
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}
