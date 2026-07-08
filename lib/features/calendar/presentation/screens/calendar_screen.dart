import 'package:easy_localization/easy_localization.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/core/constants/app_fonts.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/core/injection/dp_injection.dart';
import 'package:fire_todo/core/router/router_paths.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_all_tasks.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_tasks_by_date.dart';
import 'package:fire_todo/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:fire_todo/features/home/presentation/bloc/tasks/task_bloc.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:fire_todo/features/home/presentation/widgets/task_item_card.dart';
import 'package:fire_todo/features/home/presentation/widgets/task_not_available_widget.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../cubit/calendar_cubit.dart';

mixin CalendarScreenMixin on State<CalendarView> {
  late final AnimationController reorderController;

  void toggleTask(BuildContext context, TaskEntity task) {
    context.read<TaskBloc>().add(
          UpdateTaskEvent(taskEntity: task.copyWith(check: !task.check)),
        );

    if (!task.check) {
      reorderController.forward().then((_) {
        reorderController.reset();
      });
    }
  }

  void deleteTask(BuildContext context, TaskEntity task) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId: task.id!));
  }

  void openTaskDetail(BuildContext context, TaskEntity task) {
    final categoryName = getCategoryName(context, task.categoryId);
    context.push(
      RouterPaths.taskInfo,
      extra: {'task': task, 'categoryName': categoryName},
    );
  }

  String getCategoryName(BuildContext context, int? categoryId) {
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is CategoryLoadedState && categoryId != null) {
      try {
        final category = categoryState.categories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        return category.name;
      } catch (e) {
        return '';
      }
    }
    return '';
  }
}

mixin CalendarHelpers {
  List<DateTime> generateCalendarDays(DateTime focusedMonth) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final prevDaysCount = firstDayOfMonth.weekday - 1;
    final prevMonthLastDay = firstDayOfMonth.subtract(const Duration(days: 1));

    final List<DateTime> days = [];

    for (int i = prevDaysCount - 1; i >= 0; i--) {
      days.add(DateTime(
        prevMonthLastDay.year,
        prevMonthLastDay.month,
        prevMonthLastDay.day - i,
      ));
    }

    final lastDayOfMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateTime(focusedMonth.year, focusedMonth.month, i));
    }

    final totalCells = days.length <= 35 ? 35 : 42;
    final nextDaysCount = totalCells - days.length;
    for (int i = 1; i <= nextDaysCount; i++) {
      final nextMonthFirstDay =
          DateTime(focusedMonth.year, focusedMonth.month + 1, 1);
      days.add(DateTime(
        nextMonthFirstDay.year,
        nextMonthFirstDay.month,
        nextMonthFirstDay.day + (i - 1),
      ));
    }

    return days;
  }

  String dateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(
        getTasksByDate: getIt<GetTasksByDateUsecase>(),
        getAllTasks: getIt<GetAllTasksUsecase>(),
      )
        ..loadTasks()
        ..fetchDatesWithTasks(),
      child: const CalendarView(),
    );
  }
}

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin, CalendarScreenMixin {
  @override
  void initState() {
    super.initState();
    reorderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    reorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TasksLoadedState) {
              context.read<CalendarCubit>().loadTasks();
              context.read<CalendarCubit>().fetchDatesWithTasks();
            }
          },
        ),
      ],
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const CalendarHeader(),
              const SizedBox(height: 16),
              const WeekdayHeaderRow(),
              const SizedBox(height: 10),
              const CalendarGrid(),
              const SizedBox(height: 16),
              TasksSectionWidget(
                reorderController: reorderController,
                onToggleTask: (task) => toggleTask(context, task),
                onDeleteTask: (task) => deleteTask(context, task),
                onOpenTaskDetail: (task) => openTaskDetail(context, task),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.select(
      (CalendarCubit cubit) => cubit.state.selectedDate,
    );

    final weekdayName =
        DateFormat('EEEE', context.locale.toString()).format(selectedDate);
    final formattedDate =
        DateFormat('d,MMMM,y', context.locale.toString()).format(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlobalText(
              weekdayName,
              fontSize: 24,
              fontFamily: AppFonts.recoleta,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
              useTranslation: false,
            ),
            const SizedBox(height: 2),
            GlobalText(
              formattedDate,
              fontSize: 14,
              color: AppColors.grey300,
              fontWeight: FontWeight.w500,
              useTranslation: false,
            ),
          ],
        ),
        Row(
          children: [
            _buildArrowButton(
              icon: Icons.chevron_left,
              onTap: () =>
                  context.read<CalendarCubit>().changeSelectedDate(-1),
            ),
            const SizedBox(width: 8),
            _buildArrowButton(
              icon: Icons.chevron_right,
              onTap: () => context.read<CalendarCubit>().changeSelectedDate(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrowButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey500, width: 1.5),
          color: AppColors.grey.withValues(alpha: 0.3),
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: 18,
        ),
      ),
    );
  }
}

class WeekdayHeaderRow extends StatelessWidget {
  const WeekdayHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWeekday = context.select(
      (CalendarCubit cubit) => cubit.state.selectedDate.weekday,
    );

    final weekdayKeys = [
      AppStrings.monday,
      AppStrings.tuesday,
      AppStrings.wednesday,
      AppStrings.thursday,
      AppStrings.friday,
      AppStrings.saturday,
      AppStrings.sunday,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = (index + 1) == selectedWeekday;
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.gold : AppColors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            weekdayKeys[index].tr(),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

class CalendarGrid extends StatelessWidget with CalendarHelpers {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.select(
      (CalendarCubit cubit) => cubit.state.selectedDate,
    );
    final focusedMonth = context.select(
      (CalendarCubit cubit) => cubit.state.focusedMonth,
    );
    final datesWithTasks = context.select(
      (CalendarCubit cubit) => cubit.state.datesWithTasks,
    );

    final days = generateCalendarDays(focusedMonth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.15,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isSelected = isSameDay(day, selectedDate);
        final isTodayVal = isToday(day);
        final isCurrentMonth =
            day.month == focusedMonth.month && day.year == focusedMonth.year;
        final hasTasks = datesWithTasks.contains(dateKey(day));

        return GestureDetector(
          onTap: () => context.read<CalendarCubit>().selectDate(day),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isTodayVal)
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple,
                  ),
                ),
              if (isSelected)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                ),
              if (hasTasks)
                Positioned(
                  bottom: 2,
                  child: SvgPicture.asset(
                    AppAssets.zigzag,
                    width: 18,
                    height: 8,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gold,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              Text(
                day.day.toString(),
                style: TextStyle(
                  color: isTodayVal
                      ? AppColors.white
                      : isCurrentMonth
                          ? AppColors.white
                          : AppColors.grey400.withValues(alpha: 0.3),
                  fontSize: 14,
                  fontWeight: isSelected || isTodayVal
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TasksSectionWidget extends StatelessWidget {
  final AnimationController reorderController;
  final Function(TaskEntity) onToggleTask;
  final Function(TaskEntity) onDeleteTask;
  final Function(TaskEntity) onOpenTaskDetail;

  const TasksSectionWidget({
    super.key,
    required this.reorderController,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onOpenTaskDetail,
  });

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((CalendarCubit cubit) => cubit.state.tasks);
    final isLoading =
        context.select((CalendarCubit cubit) => cubit.state.isLoading);

    final sortedTasks = List<TaskEntity>.from(tasks);
    sortedTasks.sort((a, b) {
      if (a.check == b.check) return 0;
      return a.check ? 1 : -1;
    });

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            AppStrings.todayTask,
            fontSize: 20,
            fontFamily: AppFonts.recoleta,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isLoading ? 0.6 : 1.0,
              child: sortedTasks.isEmpty
                  ? const TaskNotAvailableWidget()
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: sortedTasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = sortedTasks[index];
                        return TaskItemCard(
                          task: task,
                          reorderController: reorderController,
                          onToggleTask: () => onToggleTask(task),
                          onDeleteTask: () => onDeleteTask(task),
                          onOpenTaskDetail: () => onOpenTaskDetail(task),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
