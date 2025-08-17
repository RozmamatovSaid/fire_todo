import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/shared/widgets/global_image.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/global_text.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.isSelected,
    required this.onDelete,
    required this.showDelete, // Qo'sh
    required this.onToggleDelete, // Qo'sh
  });

  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String title;
  final bool isSelected;
  final bool showDelete;
  final ValueChanged<bool> onToggleDelete;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  void _toggleDeleteMode() {
    widget.onToggleDelete(!widget.showDelete);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.showDelete ? widget.onDelete : widget.onTap,
        onLongPress: _toggleDeleteMode,
        borderRadius: BorderRadius.circular(39),
        highlightColor: AppColors.red.withValues(alpha: 0.4),
        splashColor: AppColors.gold.withValues(alpha: 0.5),
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          curve: Curves.ease,

          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3.5),
          decoration: BoxDecoration(
            color: widget.showDelete
                ? AppColors.red.withValues(alpha: 0.1)
                : widget.isSelected
                ? AppColors.gold
                : AppColors.background,
            borderRadius: BorderRadius.circular(widget.showDelete ? 100 : 39),
            border: Border.all(
              color: widget.showDelete
                  ? AppColors.red
                  : widget.isSelected
                  ? AppColors.gold
                  : AppColors.grey500,
            ),
          ),
          alignment: Alignment.center,
          child: widget.showDelete
              ? GlobalImage(AppAssets.trash)
              : GlobalText(
                  widget.title,
                  key: const ValueKey('title'),
                  textAlign: TextAlign.center,
                  color: widget.isSelected
                      ? AppColors.black
                      : AppColors.grey400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
        ),
      ),
    );
  }
}
