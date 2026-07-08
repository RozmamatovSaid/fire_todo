import 'package:easy_localization/easy_localization.dart';
import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/features/search/presentation/bloc/bloc/search_bloc.dart';
import 'package:fire_todo/shared/widgets/global_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../shared/global/domain/entity/task_entity.dart';
import '../../../../shared/widgets/global_text.dart';
import '../../../home/presentation/bloc/category/category_bloc.dart';
import '../../../home/presentation/widgets/task_item_card.dart';
import '../../../home/presentation/bloc/tasks/task_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _reorderController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reorderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    context.read<SearchBloc>().add(const SearchGetAllTaskEvent());
  }

  @override
  void dispose() {
    _reorderController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onToggleTask(TaskEntity task) {
    context.read<TaskBloc>().add(
      UpdateTaskEvent(taskEntity: task.copyWith(check: !task.check)),
    );

    // Animation
    if (!task.check) {
      _reorderController.forward().then((_) {
        if (mounted) _reorderController.reset();
      });
    }

    // Search ni qayta ishga tushirish (hozirgi query bilan)
    final currentQuery = _searchController.text;
    if (currentQuery.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          context.read<SearchBloc>().add(SearchTasksEvent(query: currentQuery));
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          context.read<SearchBloc>().add(const SearchGetAllTaskEvent());
        }
      });
    }
  }

  void _onDeleteTask(TaskEntity task) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId: task.id!));

    final currentQuery = _searchController.text;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        if (currentQuery.isNotEmpty) {
          context.read<SearchBloc>().add(SearchTasksEvent(query: currentQuery));
        } else {
          context.read<SearchBloc>().add(const SearchGetAllTaskEvent());
        }
      }
    });
  }

  void _openTaskDetail(TaskEntity task) {
    FocusScope.of(context).unfocus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const GlobalText(
          AppStrings.search,
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: AppStrings.tryToFindTask.tr(),
              backgroundColor: WidgetStateProperty.all(AppColors.background),
              surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              side: WidgetStateProperty.all(
                const BorderSide(color: AppColors.gold),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(39)),
              ),
              textStyle: WidgetStateProperty.all(
                const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              hintStyle: WidgetStateProperty.all(
                const TextStyle(
                  color: AppColors.grey400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: GlobalImage(AppAssets.searchNormal),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.grey400),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchBloc>().add(
                        const SearchGetAllTaskEvent(),
                      );
                      setState(() {});
                    },
                  ),
              ],
              onChanged: (query) {
                if (query.isEmpty) {
                  context.read<SearchBloc>().add(const SearchGetAllTaskEvent());
                } else {
                  context.read<SearchBloc>().add(
                    SearchTasksEvent(query: query),
                  );
                }
                setState(() {});
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return switch (state) {
                  SearchLoadingState() => const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  ),
                  SearchFailureState() => _buildErrorState(state.message),
                  SearchLoadedState() =>
                    state.taskList.isEmpty
                        ? _buildEmptyState()
                        : _buildTaskList(state.taskList),
                  _ => _buildEmptyState(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  // Error state
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          GlobalText(
            message,
            color: AppColors.white,
            fontSize: 16,
            textAlign: TextAlign.center,
            useTranslation: false,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          GlobalText(
            _searchController.text.isEmpty
                ? AppStrings.startTypingToSearch
                : AppStrings.taskNotAvailable,
            color: AppColors.grey400,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskEntity> tasks) {
    final sortedTasks = List<TaskEntity>.from(tasks);
    sortedTasks.sort((a, b) {
      if (a.check == b.check) return 0;
      return a.check ? 1 : -1;
    });

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: sortedTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return TaskItemCard(
          task: task,
          reorderController: _reorderController,
          onToggleTask: () => _onToggleTask(task),
          onDeleteTask: () => _onDeleteTask(task),
          onOpenTaskDetail: () => _openTaskDetail(task),
        );
      },
    );
  }
}
