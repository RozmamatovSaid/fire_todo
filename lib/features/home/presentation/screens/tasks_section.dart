import 'package:fire_todo/core/router/router_paths.dart';
import 'package:fire_todo/features/home/presentation/widgets/task_not_available_widget.dart';
import 'package:fire_todo/features/home/presentation/widgets/task_item_card.dart';
import 'package:fire_todo/features/main/index.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection>
    with TickerProviderStateMixin {
  late AnimationController _reorderController;

  @override
  void initState() {
    super.initState();
    _reorderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _reorderController.dispose();
    super.dispose();
  }

  // Task toggle qilish (soddalashtirilgan)
  void _toggleTask(TaskEntity task) {
    context.read<TaskBloc>().add(
      UpdateTaskEvent(taskEntity: task.copyWith(check: !task.check)),
    );

    // Animation faqat task complete bo'lganda
    if (!task.check) {
      _playCompleteAnimation();
    }
  }

  // Task delete qilish
  void _deleteTask(TaskEntity task) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId: task.id!));
  }

  void _openTaskDetail(TaskEntity task) {
    final categoryName = _getCategoryName(task.categoryId);

    context.push(
      RouterPaths.taskInfo,
      extra: {'task': task, 'categoryName': categoryName},
    );
  }

  String _getCategoryName(int? categoryId) {
    final categoryState = context.read<CategoryBloc>().state;

    if (categoryState is CategoryLoadedState && categoryId != null) {
      try {
        final category = categoryState.categories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        return category.name;
      } catch (e) {
        return 'Unknown Category';
      }
    }
    return 'No Category';
  }

  // Complete animation play qilish
  void _playCompleteAnimation() {
    _reorderController.forward().then((_) {
      if (mounted) {
        _reorderController.reset();
      }
    });
  }

  // Tasklarni sort qilish (completed tasklar pastga)
  List<TaskEntity> _sortTasks(List<TaskEntity> tasks) {
    final sortedTasks = List<TaskEntity>.from(tasks);
    sortedTasks.sort((a, b) {
      if (a.check == b.check) return 0;
      return a.check ? 1 : -1; // completed tasklar pastda
    });
    return sortedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return switch (state) {
          // Loading states
          TaskInitialState() || TaskLoadingState() => _buildLoadingState(),

          // Error state
          TaskFailureState() => _buildErrorState(),

          // Loaded state
          TasksLoadedState() =>
            state.taskEntity.isEmpty
                ? _buildEmptyState()
                : _buildTaskList(state.taskEntity),

          // Default state
          _ => _buildEmptyState(),
        };
      },
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.gold),
    );
  }

  // Error state widget
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/error.json", width: 200),
          const SizedBox(height: 16),
          GlobalText(
            AppStrings.somethingWentWrong.tr(),
            color: AppColors.grey400,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return const TaskNotAvailableWidget();
  }

  Widget _buildTaskList(List<TaskEntity> tasks) {
    final sortedTasks = _sortTasks(tasks);

    return ReorderableListView.builder(
      padding: const EdgeInsets.only(bottom: 40),
      buildDefaultDragHandles: false,
      itemCount: sortedTasks.length,
      onReorderItem: (oldIndex, newIndex) {
        final item = sortedTasks.removeAt(oldIndex);
        sortedTasks.insert(newIndex, item);

        final updatedTasks = <TaskEntity>[];
        for (int i = 0; i < sortedTasks.length; i++) {
          updatedTasks.add(sortedTasks[i].copyWith(orderIndex: i));
        }

        context.read<TaskBloc>().add(ReorderTasksEvent(tasks: updatedTasks));
      },
      itemBuilder: (context, index) {
        final task = sortedTasks[index];

        return ReorderableDragStartListener(
          key: ValueKey(task.id),
          index: index,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TaskItemCard(
              task: task,
              reorderController: _reorderController,
              onToggleTask: () => _toggleTask(task),
              onDeleteTask: () => _deleteTask(task),
              onOpenTaskDetail: () => _openTaskDetail(task),
            ),
          ),
        );
      },
    );
  }
}
