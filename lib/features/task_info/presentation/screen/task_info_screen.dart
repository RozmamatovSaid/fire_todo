import 'package:fire_todo/shared/global/domain/entity/category_entity.dart';
import 'package:fire_todo/features/home/presentation/widgets/task_info_item_card.dart';
import 'package:fire_todo/features/main/index.dart';
import 'package:fire_todo/shared/dialogs/confirm_delete_dialog.dart';
import 'package:fire_todo/features/task_info/presentation/widgets/custom_date_picker.dart';
import 'package:fire_todo/features/task_info/presentation/widgets/custom_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bloc/task_info_bloc.dart';

class TaskInfo extends StatelessWidget {
  const TaskInfo({super.key, required this.task, this.categoryName});

  final TaskEntity task;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskInfoBloc(taskBloc: context.read<TaskBloc>())
            ..add(InitTaskInfoEvent(task: task, categoryName: categoryName)),
      child: const _TaskInfoView(),
    );
  }
}

class _TaskInfoView extends StatelessWidget {
  const _TaskInfoView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskInfoBloc, TaskInfoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.outlined(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.grey400),
                  ),
                  onPressed: () => context.pop(),
                  icon: GlobalImage(AppAssets.arrowLeft),
                ),
                IconButton.outlined(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.red.withValues(alpha: 0.15),
                    side: BorderSide(
                      color: AppColors.red.withValues(alpha: 0.05),
                    ),
                  ),
                  onPressed: () => _deleteTask(context, state.task),
                  icon: GlobalImage(AppAssets.trash),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task title
                GlobalText(
                  state.task.title,
                  fontSize: 24,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  useTranslation: false,
                ),
                const SizedBox(height: 12),

                // Task description
                GlobalText(
                  state.task.description ?? '',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: AppColors.white,
                  useTranslation: false,
                ),
                const Spacer(),

                // Task options
                Column(
                  spacing: 8,
                  children: [
                    // Category Selector
                    _buildCategorySelector(context, state),

                    // Date Picker
                    _buildDatePicker(context, state),

                    // Time Picker
                    _buildTimePicker(context, state),

                    // Priority Selector
                    _buildPrioritySelector(context, state),

                    // Notify Me
                    _buildNotifyToggle(context, state),
                  ],
                ),
                const Spacer(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  // Category Selector Widget
  Widget _buildCategorySelector(BuildContext context, TaskInfoState state) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      bloc: context.read<CategoryBloc>(),
      builder: (context, categoryState) {
        if (categoryState is CategoryLoadedState) {
          return TaskInfoItemCard(
            leadingIconPath: AppAssets.category,
            title: AppStrings.category,
            trailing: CupertinoButton(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(32),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlobalText(state.categoryName),
              onPressed: () =>
                  _showCategoryPicker(context, categoryState.categories),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Date Picker Widget
  Widget _buildDatePicker(BuildContext context, TaskInfoState state) {
    return TaskInfoItemCard(
      leadingIconPath: AppAssets.calendar,
      title: AppStrings.dueDate,
      trailing: CupertinoButton(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(32),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        onPressed: () => _showDatePicker(context),
        child: GlobalText(
          state.selectedDate != null
              ? _formatDate(state.selectedDate)
              : AppStrings.selectDate.tr(),
          useTranslation: state.selectedDate == null,
        ),
      ),
    );
  }

  // Time Picker Widget
  Widget _buildTimePicker(BuildContext context, TaskInfoState state) {
    return TaskInfoItemCard(
      leadingIconPath: AppAssets.clock,
      title: AppStrings.time,
      trailing: CupertinoButton(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(32),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        onPressed: () => _showTimePicker(context, state),
        child: GlobalText(
          _getTimeDisplayText(state),
          useTranslation:
              state.selectedDate != null && state.selectedTime == null,
        ),
      ),
    );
  }

  // Priority Selector Widget
  Widget _buildPrioritySelector(BuildContext context, TaskInfoState state) {
    return TaskInfoItemCard(
      leadingIconPath: AppAssets.flagYellow,
      title: AppStrings.priority,
      trailing: CupertinoButton(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(32),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalImage(
              _getPriorityIcon(state.selectedPriority),
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 6),
            GlobalText(
              _getPriorityName(state.selectedPriority),
              useTranslation: false,
            ),
          ],
        ),
        onPressed: () => _showPriorityPicker(context),
      ),
    );
  }

  // Notify Toggle Widget
  Widget _buildNotifyToggle(BuildContext context, TaskInfoState state) {
    return TaskInfoItemCard(
      leadingIconPath: AppAssets.notificationBing,
      title: AppStrings.notifyMe,
      trailing: Switch(
        value: state.isNotify,
        onChanged: (value) {
          context.read<TaskInfoBloc>().add(UpdateNotifyEvent(notify: value));
        },
      ),
    );
  }

  // Category Picker
  Future<void> _showCategoryPicker(
    BuildContext context,
    List<CategoryEntity> categories,
  ) async {
    final selectedCategory = await showMenu<CategoryEntity>(
      context: context,
      color: AppColors.darkGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      position: _centerMenuPosition(context),
      items: categories
          .map(
            (category) => PopupMenuItem<CategoryEntity>(
              value: category,
              child: Row(
                children: [
                  Icon(CupertinoIcons.circle, color: AppColors.white),
                  const SizedBox(width: 12),
                  GlobalText(
                    category.name,
                    color: AppColors.white,
                    useTranslation: false,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );

    if (!context.mounted || selectedCategory == null) return;

    context.read<TaskInfoBloc>().add(
      UpdateCategoryEvent(category: selectedCategory),
    );
  }

  // Date Picker
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await CustomDatePicker.show(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      title: AppStrings.selectDate.tr(),
      primaryColor: AppColors.gold,
      backgroundColor: AppColors.darkGrey,
      surfaceColor: AppColors.grey700,
      textColor: AppColors.white,
      selectedColor: AppColors.purple,
      todayColor: AppColors.grey500,
    );

    if (!context.mounted || pickedDate == null) return;

    context.read<TaskInfoBloc>().add(UpdateDateEvent(date: pickedDate));
  }

  // Time Picker
  Future<void> _showTimePicker(
    BuildContext context,
    TaskInfoState state,
  ) async {
    if (state.selectedDate == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: GlobalText(
              AppStrings.pleaseSelectDateFirst,
              color: AppColors.white,
              useTranslation: false,
            ),
            backgroundColor: AppColors.gold,
          ),
        );
      return;
    }

    final TimeOfDay? pickedTime = await CustomTimePicker.show(
      context,
      initialTime: state.selectedTime ?? TimeOfDay.now(),
      title: AppStrings.selectTime.tr(),
      primaryColor: AppColors.gold,
      backgroundColor: AppColors.darkGrey,
      surfaceColor: AppColors.grey700,
      textColor: AppColors.white,
      use24HourFormat: false,
    );

    if (!context.mounted || pickedTime == null) return;

    context.read<TaskInfoBloc>().add(UpdateTimeEvent(time: pickedTime));
  }

  // Priority Picker
  Future<void> _showPriorityPicker(BuildContext context) async {
    final priorities = [
      {
        'name': AppStrings.priorityLow.tr(),
        'icon': AppAssets.flagGreen,
        'value': TaskPriority.low,
      },
      {
        'name': AppStrings.priorityMedium.tr(),
        'icon': AppAssets.flagYellow,
        'value': TaskPriority.medium,
      },
      {
        'name': AppStrings.priorityHigh.tr(),
        'icon': AppAssets.flagRed,
        'value': TaskPriority.high,
      },
    ];

    final selectedPriority = await showMenu<TaskPriority>(
      context: context,
      color: AppColors.darkGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      position: _centerMenuPosition(context),
      items: priorities
          .map(
            (priority) => PopupMenuItem<TaskPriority>(
              value: priority['value'] as TaskPriority,
              child: Row(
                children: [
                  GlobalImage(
                    priority['icon'] as String,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 12),
                  GlobalText(
                    priority['name'] as String,
                    color: AppColors.white,
                    useTranslation: false,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );

    if (!context.mounted || selectedPriority == null) return;

    context.read<TaskInfoBloc>().add(
      UpdatePriorityEvent(priority: selectedPriority),
    );
  }

  // Delete Task
  void _deleteTask(BuildContext context, TaskEntity task) async {
    final bool? shouldDelete = await DeleteConfirmationDialog.show(
      title: task.title,
      context: context,
      onPressed: () {
        context.read<TaskBloc>().add(DeleteTaskEvent(taskId: task.id!));
        Navigator.of(context).pop(true);
      },
    );

    if (!context.mounted || shouldDelete != true) return;

    context.pop();
  }

  // Helper Methods
  String _getPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppStrings.priorityLow.tr();
      case TaskPriority.medium:
        return AppStrings.priorityMedium.tr();
      case TaskPriority.high:
        return AppStrings.priorityHigh.tr();
    }
  }

  String _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppAssets.flagGreen;
      case TaskPriority.medium:
        return AppAssets.flagYellow;
      case TaskPriority.high:
        return AppAssets.flagRed;
    }
  }

  RelativeRect _centerMenuPosition(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final centerRect = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: 0,
      height: 0,
    );

    return RelativeRect.fromRect(centerRect, Offset.zero & screenSize);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return AppStrings.noDate.tr();

    final List<String> monthKeys = [
      AppStrings.monthShortJan,
      AppStrings.monthShortFeb,
      AppStrings.monthShortMar,
      AppStrings.monthShortApr,
      AppStrings.monthShortMay,
      AppStrings.monthShortJun,
      AppStrings.monthShortJul,
      AppStrings.monthShortAug,
      AppStrings.monthShortSep,
      AppStrings.monthShortOct,
      AppStrings.monthShortNov,
      AppStrings.monthShortDec,
    ];

    return "${date.day} ${monthKeys[date.month - 1].tr()} ${date.year}";
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return AppStrings.selectTime.tr();

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am
        ? AppStrings.am.tr()
        : AppStrings.pm.tr();
    return '$hour:$minute $period';
  }

  String _getTimeDisplayText(TaskInfoState state) {
    if (state.selectedDate == null) {
      return AppStrings.pleaseSelectDateFirst.tr();
    } else if (state.selectedTime == null) {
      return AppStrings.selectTime.tr();
    } else {
      return _formatTime(state.selectedTime);
    }
  }
}
