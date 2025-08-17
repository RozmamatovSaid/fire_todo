// shared/widgets/main_scaffold_wrapper.dart
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/shared/dialogs/add_task.dart';
import 'package:fire_todo/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final ValueNotifier<int> selectedIndex;
  final Function(int) onTabChanged;
  int? preSelectedCategoryId;

  MainScaffoldWrapper({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.preSelectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        body: body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.background, width: 4),
            ),
            backgroundColor: AppColors.purple,
            child: const Icon(Icons.add, color: AppColors.white),
            onPressed: () => showAddTaskDialog(context, preSelectedCategoryId),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, index, _) => CustomBottomNavigationBar(
            selectedIndex: index,
            onItemTap: onTabChanged,
          ),
        ),
      ),
    );
  }
}
