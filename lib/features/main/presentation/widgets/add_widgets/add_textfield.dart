import 'package:fire_todo/features/main/index.dart';
import 'package:flutter/material.dart';

// Text Fields Widget
class AddTextField extends StatelessWidget {
  const AddTextField({
    super.key,
    required this.controllerTitle,
    required this.controllerDescription,
  });

  final TextEditingController controllerTitle;
  final TextEditingController controllerDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      children: [
        TextField(
          controller: controllerTitle,
          cursorColor: AppColors.gold,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppStrings.inputTaskNameHere.tr(),
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF121212),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        TextField(
          controller: controllerDescription,
          cursorColor: AppColors.gold,
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppStrings.inputNewTask.tr(),
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF121212),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
