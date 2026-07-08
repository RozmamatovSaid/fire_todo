import 'package:fire_todo/core/constants/app_fonts.dart';
import 'package:fire_todo/features/home/presentation/widgets/category_item.dart';
import 'package:fire_todo/features/home/presentation/widgets/dotted_add_button.dart';
import 'package:fire_todo/features/search/presentation/widgets/search_textfield.dart';
import 'package:fire_todo/features/home/presentation/screens/tasks_section.dart';
import 'package:fire_todo/features/home/presentation/widgets/to_do_badge.dart';
import 'package:fire_todo/shared/dialogs/add_category.dart';
import 'package:fire_todo/shared/widgets/action_button.dart';
import 'package:flutter/material.dart';
import '../../../../shared/dialogs/confirm_delete_dialog.dart';
import 'package:fire_todo/features/main/index.dart';
import '../../../../shared/global/domain/entity/category_entity.dart';

import 'package:fire_todo/core/router/router_paths.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.name,
    required this.onSelectedCategoryChanged,
  });
  final String? name;
  final Function(int? categoryId)? onSelectedCategoryChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<String?> activeDeleteId;
  late ValueNotifier<int?> selectedCategoryId;
  late ValueNotifier<bool> isAllTasksSelected;
  late ValueNotifier<bool> hasSetDefaultCategory;

  @override
  void initState() {
    super.initState();
    activeDeleteId = ValueNotifier<String?>(null);
    selectedCategoryId = ValueNotifier<int?>(null);
    isAllTasksSelected = ValueNotifier<bool>(false);
    hasSetDefaultCategory = ValueNotifier<bool>(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CategoryBloc>().add(const GetAllCategoriesEvent());
      }
    });
  }

  @override
  void dispose() {
    activeDeleteId.dispose();
    selectedCategoryId.dispose();
    isAllTasksSelected.dispose();
    hasSetDefaultCategory.dispose();
    super.dispose();
  }

  void _selectAllTasks() {
    isAllTasksSelected.value = true;
    selectedCategoryId.value = null;

    widget.onSelectedCategoryChanged?.call(null);
    context.read<TaskBloc>().add(const GetAllTasksEvent());
  }

  void _selectCategory(int categoryId, String categoryName) {
    isAllTasksSelected.value = false;
    selectedCategoryId.value = categoryId;

    widget.onSelectedCategoryChanged?.call(categoryId);
    context.read<TaskBloc>().add(
      GetTasksByCategoryEvent(categoryId: categoryId),
    );
  }

  void _handleCategoryDelete(int categoryId) {
    context.read<CategoryBloc>().add(DeleteCategoryEvent(id: categoryId));
    Navigator.of(context).pop();
    activeDeleteId.value = null;

    if (!isAllTasksSelected.value && selectedCategoryId.value == categoryId) {
      _selectAllTasks();
    }
  }

  void _handleEmptyCategories() {
    hasSetDefaultCategory.value = false;
    isAllTasksSelected.value = false;
    selectedCategoryId.value = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectedCategoryChanged?.call(null);
      context.read<TaskBloc>().add(const GetAllTasksEvent());
    });
  }

  void _setDefaultSelection() {
    hasSetDefaultCategory.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectAllTasks());
  }

  Future<void> _showAddCategoryDialog() async {
    final result = await showAddCategoryDialog(context, '');
    if (result?.isNotEmpty == true && mounted) {
      context.read<CategoryBloc>().add(AddCategoryEvent(name: result!.trim()));
    }
  }

  void _showDeleteConfirmation(CategoryEntity category) {
    DeleteConfirmationDialog.show(
      context: context,
      title: category.name,
      onPressed: () => _handleCategoryDelete(category.id),
    );
  }

  void _handleCategoryStateChange(CategoryLoadedState state) {
    if (state.categories.isEmpty) {
      _handleEmptyCategories();
    } else if (!hasSetDefaultCategory.value) {
      _setDefaultSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // USER INFO
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: GlobalText(
                            widget.name ?? "",
                            fontSize: 24,
                            fontFamily: AppFonts.recoleta,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            useTranslation: false,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-30, -5),
                          child: const ToDoBadge(),
                        ),
                      ],
                    ),
                  ),
                  // SETTINGS BUTTON
                  ActionButton(
                    icon: AppAssets.settings,
                    onTap: () => context.push(RouterPaths.settings),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SearchTextfield(),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // CATEGORY SECTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 50,
            child: BlocConsumer<CategoryBloc, CategoryState>(
              listenWhen: (previous, current) => current is CategoryLoadedState,
              listener: (context, state) {
                if (state is CategoryLoadedState) {
                  _handleCategoryStateChange(state);
                }
              },
              builder: (context, state) {
                final rowChildren = <Widget>[
                  DottedAddButton(
                    onTap: _showAddCategoryDialog,
                    highlight:
                        state is CategoryLoadedState &&
                        state.categories.isEmpty,
                  ),
                ];

                if (state is! CategoryLoadedState) {
                  if (state is CategoryFailureState) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 16,
                            color: Colors.red[300],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Yuklanmadi',
                            style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                rowChildren.add(const SizedBox(width: 8));

                if (state.categories.isNotEmpty) {
                  // ALL TASK BUTTON
                  rowChildren.add(
                    ValueListenableBuilder<bool>(
                      valueListenable: isAllTasksSelected,
                      builder: (context, isSelected, child) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(39),
                            highlightColor: AppColors.gold.withValues(
                              alpha: 0.2,
                            ),
                            splashColor: AppColors.gold.withValues(alpha: 0.1),
                            onTap: _selectAllTasks,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.background,
                                border: BoxBorder.all(
                                  color: isSelected
                                      ? AppColors.gold
                                      : AppColors.grey500,
                                ),

                                borderRadius: BorderRadius.circular(39),
                              ),
                              alignment: Alignment.center,
                              child: GlobalText(
                                AppStrings.allTask,
                                color: isSelected
                                    ? AppColors.black
                                    : AppColors.grey400,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                  rowChildren.add(const SizedBox(width: 8));

                  for (final category in state.categories) {
                    rowChildren.add(
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ValueListenableBuilder<String?>(
                          valueListenable: activeDeleteId,
                          builder: (context, activeId, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: isAllTasksSelected,
                              builder: (context, allTasksSelected, child) {
                                return ValueListenableBuilder<int?>(
                                  valueListenable: selectedCategoryId,
                                  builder: (context, selectedId, child) {
                                    return CategoryItem(
                                      key: ValueKey(category.id),
                                      onTap: () => _selectCategory(
                                        category.id,
                                        category.name,
                                      ),
                                      title: category.name,
                                      isSelected:
                                          !allTasksSelected &&
                                          selectedId == category.id,
                                      showDelete:
                                          activeId == category.id.toString(),
                                      onToggleDelete: (show) =>
                                          activeDeleteId.value = show
                                          ? category.id.toString()
                                          : null,
                                      onDelete: () =>
                                          _showDeleteConfirmation(category),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                }

                return Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: rowChildren,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TasksSection(),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
