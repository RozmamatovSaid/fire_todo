import 'package:fire_todo/features/main/index.dart';
import 'package:fire_todo/shared/dialogs/coming_soon.dart';
import 'package:flutter/material.dart';

import '../../features/main/presentation/widgets/add_widgets/add_task_dropdown.dart';
import '../../features/main/presentation/widgets/add_widgets/select_flag.dart';

Future<void> showAddTaskDialog(
  BuildContext context,
  int? preSelectedCategoryId,
) async {
  int flagIndex = 0;
  DateTime? selectedDateTime;
  bool notificationEnabled = false;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  final categoryState = context.read<CategoryBloc>().state;

  if (categoryState is! CategoryLoadedState ||
      categoryState.categories.isEmpty) {
    showComingSoonDialog(context);
    return;
  }

  // Default category tanlash mantigi
  int selectedCategoryId;

  if (preSelectedCategoryId != null) {
    // Agar preSelectedCategoryId berilgan bo'lsa va u mavjud bo'lsa
    final categoryExists = categoryState.categories.any(
      (cat) => cat.id == preSelectedCategoryId,
    );
    selectedCategoryId = categoryExists
        ? preSelectedCategoryId
        : categoryState.categories.first.id;
  } else {
    // Agar preSelectedCategoryId null bo'lsa, birinchi categoryni tanlang
    selectedCategoryId = categoryState.categories.first.id;
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  bottom: keyboardHeight + 20,
                  left: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Input fields
                                    AddTextField(
                                      controllerTitle: controllerTitle,
                                      controllerDescription:
                                          controllerDescription,
                                    ),
                                    16.g,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Category Dropdown - default qiymat berish
                                        AddTaskDropDownButton(
                                          initialCategoryId:
                                              selectedCategoryId, // Default qiymat
                                          onCategorySelected: (categoryId) {
                                            selectedCategoryId = categoryId;
                                          },
                                        ),
                                        const SizedBox(width: 8),

                                        // Flag Selector
                                        AddTaskSelectFlag(
                                          onFlagSelected: (index) {
                                            flagIndex = index;
                                          },
                                        ),
                                        const SizedBox(width: 8),

                                        // Calendar Button
                                        CalendarButton(
                                          onDateTimeSelected: (dateTime) {
                                            selectedDateTime = dateTime;
                                          },
                                          onNotificationSelected: (enabled) {
                                            notificationEnabled = enabled;
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    // Add Task Button
                                    ListenableBuilder(
                                      listenable: controllerTitle,
                                      builder: (context, child) {
                                        return AppButton(
                                          text: AppStrings.addNewTask.tr(),
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (controllerTitle.text.isNotEmpty) {
                                              // TaskEntity yaratish
                                              final newTask = TaskEntity(
                                                title: controllerTitle.text,
                                                description:
                                                    controllerDescription
                                                        .text
                                                        .isEmpty
                                                    ? null
                                                    : controllerDescription.text,
                                                categoryId: selectedCategoryId,
                                                priority:
                                                    TaskPriority.values[flagIndex],
                                                check: false,
                                                notify: notificationEnabled,
                                                createdAt: DateTime.now(),
                                                dueAt: selectedDateTime,
                                              );

                                              // Bloc orqali task qo'shish
                                              context.read<TaskBloc>().add(
                                                AddTaskEvent(taskEntity: newTask),
                                              );

                                              // Dialog yopish
                                              Navigator.of(dialogContext).pop();
                                            }
                                          },
                                          isEnable: controllerTitle.text.isNotEmpty,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          top: -80,
                          right: 0,
                          left: 0,
                          child: CustomCloseButton(
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
