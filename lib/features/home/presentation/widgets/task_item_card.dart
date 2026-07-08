import 'package:flutter/material.dart';
import '../../../main/index.dart';

class TaskItemCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggleTask;
  final VoidCallback onDeleteTask;
  final VoidCallback onOpenTaskDetail;
  final AnimationController reorderController;

  const TaskItemCard({
    super.key,
    required this.task,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onOpenTaskDetail,
    required this.reorderController,
  });

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: GlobalText(AppStrings.deleteTask, color: AppColors.white),
          content: GlobalText(
            useTranslation: false,
            AppStrings.deleteTaskConfirm.tr(args: [task.title]),
            color: AppColors.grey400,
          ),
          actions: [
            TextButton(
              child: GlobalText(AppStrings.cancel, color: AppColors.grey400),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: GlobalText(AppStrings.delete, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  // Date format qilish
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return AppStrings.today.tr();
    } else if (taskDate == tomorrow) {
      return AppStrings.tomorrow.tr();
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      if (difference == 1) {
        return "1 ${AppStrings.dayAgo.tr()}";
      } else {
        return "$difference ${AppStrings.daysAgo.tr()}";
      }
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: reorderController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, task.check ? reorderController.value * 20 : 0),
          child: Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GlobalImage(
                    AppAssets.trash,
                    color: AppColors.white,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  GlobalText(
                    AppStrings.delete,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              return await _showDeleteConfirmation(context);
            },
            onDismissed: (direction) {
              onDeleteTask();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: task.check
                    ? AppColors.grey.withValues(alpha: 0.5)
                    : AppColors.grey,
                borderRadius: BorderRadius.circular(16),
                border: task.check
                    ? Border.all(
                        color: AppColors.grey400.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  highlightColor: AppColors.gold.withValues(alpha: 0.1),
                  splashColor: AppColors.gold.withValues(alpha: 0.2),
                  onTap: onOpenTaskDetail,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: task.check ? 0.6 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: onToggleTask,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: task.check
                                        ? AppColors.purple
                                        : AppColors.grey400,
                                    width: 2,
                                  ),
                                  color: task.check
                                      ? AppColors.purple
                                      : Colors.transparent,
                                ),
                                child: task.check
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColors.black,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // TASK CONTENT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: task.check
                                              ? AppColors.grey400
                                              : AppColors.white,
                                          decoration: task.check
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          decorationColor: AppColors.grey400,
                                          decorationThickness: 2,
                                          fontWeight: task.check
                                              ? FontWeight.w400
                                              : FontWeight.w500,
                                        ),
                                        child: Text(
                                          task.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    if (task.check) ...[
                                      const SizedBox(width: 8),
                                      AnimatedScale(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        scale: task.check ? 1.0 : 0.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.gold.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: AppColors.gold,
                                              width: 1,
                                            ),
                                          ),
                                          child: GlobalText(
                                            AppStrings.done,
                                            color: AppColors.gold,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: task.check
                                            ? AppColors.grey400.withValues(alpha: 0.7)
                                            : AppColors.grey400,
                                      ),
                                      const SizedBox(width: 4),
                                      GlobalText(
                                        task.dueAt != null
                                            ? _formatDate(task.dueAt!)
                                            : AppStrings.noDate,
                                        color: task.check
                                            ? AppColors.grey400.withValues(alpha: 0.7)
                                            : AppColors.grey400,
                                        fontSize: 12,
                                      ),
                                      if (task.description != null &&
                                          task.description!.isNotEmpty) ...[
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.description,
                                          size: 14,
                                          color: task.check
                                              ? AppColors.grey400.withValues(
                                                  alpha: 0.7,
                                                )
                                              : AppColors.grey400,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // PRIORITY FLAG
                          AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale: task.check ? 0.8 : 1.0,
                            child: GlobalImage(
                              switch (task.priority) {
                                TaskPriority.low => AppAssets.flagGreen,
                                TaskPriority.medium => AppAssets.flagYellow,
                                TaskPriority.high => AppAssets.flagRed,
                              },
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
