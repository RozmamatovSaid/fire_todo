import 'package:flutter/material.dart';
import '../../../main/index.dart';

class TaskInfoItemCard extends StatelessWidget {
  const TaskInfoItemCard({
    super.key,
    required this.leadingIconPath,
    required this.title,
    required this.trailing,
  });
  final String leadingIconPath;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        // AppAssets.category
        leading: GlobalImage(
          leadingIconPath,
          width: 24,
          height: 24,
          color: AppColors.white,
        ),
        title: GlobalText(title, fontSize: 15, color: AppColors.white),
        trailing: trailing,
      ),
    );
  }
}
