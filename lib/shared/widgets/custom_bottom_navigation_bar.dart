import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/shared/widgets/global_image.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });
  final int selectedIndex;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.grey),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 27, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavItem(
                title: "Home",
                icon: AppAssets.home,
                onTap: () => onItemTap(0),
                isSelected: selectedIndex == 0,
              ),
              BottomNavItem(
                title: "Calendar",
                icon: AppAssets.calendar,
                onTap: () => onItemTap(1),
                isSelected: selectedIndex == 1,
              ),
              SizedBox(width: 30),
              BottomNavItem(
                title: "Category",
                icon: AppAssets.category,
                onTap: () => onItemTap(2),
                isSelected: selectedIndex == 2,
              ),
              BottomNavItem(
                title: "Graph",
                icon: AppAssets.graph,
                onTap: () => onItemTap(3),
                isSelected: selectedIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isSelected,
  });
  final String title, icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        spacing: 2,
        children: [
          GlobalImage(
            icon,
            color: isSelected ? AppColors.white : AppColors.grey400,
          ),
          GlobalText(
            title,
            color: isSelected ? AppColors.white : AppColors.grey400,
          ),
        ],
      ),
    );
  }
}
