import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/constants/app_fonts.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/core/injection/dp_injection.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_tasks_by_category.dart';
import 'package:fire_todo/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:fire_todo/shared/global/domain/entity/category_entity.dart';
import 'package:fire_todo/shared/dialogs/add_category.dart';
import 'package:fire_todo/shared/dialogs/confirm_delete_dialog.dart';
import 'package:fire_todo/shared/dialogs/coming_soon.dart';
import 'package:fire_todo/shared/widgets/action_button.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CategoryScreenMixin {
  Map<String, String> splitEmojiAndName(String name) {
    if (name.isEmpty) return {'emoji': '', 'name': ''};
    final RegExp emojiRegex = RegExp(
      r'^([\u{1F300}-\u{1F9FF}]|[\u{1F600}-\u{1F64F}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F1E6}-\u{1F1FF}]|[\u{1F900}-\u{1F9FF}])\s*(.*)$',
      unicode: true,
    );
    final match = emojiRegex.firstMatch(name);
    if (match != null) {
      return {
        'emoji': match.group(1) ?? '',
        'name': match.group(2) ?? '',
      };
    }
    return {'emoji': '', 'name': name};
  }

  Future<void> handleAddCategory(BuildContext context) async {
    final result = await showAddCategoryDialog(context, '');
    if (result != null && result.trim().isNotEmpty) {
      if (context.mounted) {
        context.read<CategoryBloc>().add(AddCategoryEvent(name: result.trim()));
      }
    }
  }

  Future<void> handleEditCategory(BuildContext context, CategoryEntity category) async {
    final parts = splitEmojiAndName(category.name);
    final initialEmoji = parts['emoji'] ?? '';
    final initialName = parts['name'] ?? '';

    final result = await showAddCategoryDialog(
      context,
      initialEmoji,
      initialName: initialName,
    );

    if (result != null && result.trim().isNotEmpty) {
      if (context.mounted) {
        context.read<CategoryBloc>().add(
              EditCategoryEvent(
                category: CategoryEntity(id: category.id, name: result.trim()),
              ),
            );
      }
    }
  }

  void handleDeleteCategory(BuildContext context, CategoryEntity category) {
    DeleteConfirmationDialog.show(
      context: context,
      title: category.name,
      onPressed: () {
        context.read<CategoryBloc>().add(DeleteCategoryEvent(id: category.id));
        Navigator.of(context).pop();
      },
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    this.color = AppColors.grey500,
    this.strokeWidth = 1,
    this.gap = 4,
    this.dashLength = 6,
    this.borderRadius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final dashPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CategoryScreen extends StatelessWidget with CategoryScreenMixin {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalText(
                    AppStrings.category,
                    fontSize: 28,
                    fontFamily: AppFonts.recoleta,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  ActionButton(
                    icon: AppAssets.settings,
                    onTap: () => showComingSoonDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Center(
                child: GlobalText(
                  AppStrings.categoriesDisplayOnHomepage,
                  fontSize: 13,
                  color: AppColors.grey300,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              const GlobalText(
                AppStrings.manageCategories,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      );
                    }
                    if (state is CategoryLoadedState) {
                      final categories = state.categories;
                      return ListView.builder(
                        itemCount: categories.length + 1,
                        padding: const EdgeInsets.only(bottom: 24),
                        itemBuilder: (context, index) {
                          if (index == categories.length) {
                            return GestureDetector(
                              onTap: () => handleAddCategory(context),
                              child: CustomPaint(
                                painter: DashedBorderPainter(),
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GlobalText(
                                        "+",
                                        fontSize: 18,
                                        color: AppColors.grey400,
                                        fontWeight: FontWeight.bold,
                                        useTranslation: false,
                                      ),
                                      SizedBox(width: 8),
                                      GlobalText(
                                        AppStrings.createNewCategory,
                                        fontSize: 14,
                                        color: AppColors.grey400,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          final category = categories[index];
                          return CategoryCard(
                            category: category,
                            onEdit: () => handleEditCategory(context, category),
                            onDelete: () => handleDeleteCategory(context, category),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.5),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.grey400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.grey400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  category.name,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  useTranslation: false,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                FutureBuilder(
                  future: getIt<GetTasksByCategoryIdUsecase>().call(category.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      );
                    }
                    final tasks = snapshot.data?.getOrElse(() => []) ?? [];
                    final total = tasks.length;
                    final completed = tasks.where((t) => t.check).length;
                    return GlobalText(
                      "$completed/$total task",
                      fontSize: 14,
                      color: AppColors.gold,
                      useTranslation: false,
                    );
                  },
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: AppColors.white),
            color: AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: AppColors.white, size: 18),
                    const SizedBox(width: 8),
                    GlobalText(
                      AppStrings.edit,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    GlobalText(
                      AppStrings.delete,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
