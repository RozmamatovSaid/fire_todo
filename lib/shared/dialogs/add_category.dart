import 'package:easy_localization/easy_localization.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/features/home/presentation/widgets/add_emojie_button.dart';
import 'package:fire_todo/shared/widgets/app_button.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

Future<String?> showAddCategoryDialog(
  BuildContext context,
  String newEmoji, {
  String initialName = '',
}) async {
  final TextEditingController controller =
      TextEditingController(text: initialName);

  final result = await showDialog<String>(
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
                                    TextField(
                                      cursorColor: AppColors.gold,
                                      controller: controller,
                                      onChanged: (_) => setState(() {}),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          onPressed: () {
                                            showEmojiPicker(
                                              context,
                                              (emoji) {
                                                setState(() {
                                                  newEmoji = emoji;
                                                });
                                              },
                                            );
                                          },
                                          icon: newEmoji != ''
                                              ? GlobalText(
                                                  newEmoji,
                                                  fontSize: 20,
                                                  useTranslation: false,
                                                )
                                              : const Icon(Icons.emoji_emotions),
                                        ),
                                        hintText: AppStrings.enterCategoryName
                                            .tr(),
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFF121212),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    AppButton(
                                      text: AppStrings.addNewCategory.tr(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        final text = controller.text.trim();
                                        if (controller.text.isEmpty &&
                                            newEmoji.isEmpty) {
                                          return;
                                        }
                                        final result =
                                            (newEmoji.isNotEmpty &&
                                                text.isNotEmpty)
                                            ? "$newEmoji $text"
                                            : (newEmoji.isNotEmpty)
                                            ? newEmoji
                                            : text;
                                        if (controller.text.isNotEmpty ||
                                            newEmoji.isNotEmpty) {
                                          Navigator.of(
                                            dialogContext,
                                          ).pop(result);
                                        }
                                      },
                                      isEnable:
                                          controller.text.isNotEmpty ||
                                          newEmoji.isNotEmpty,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: -80,
                          right: 0,
                          left: 0,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.grey700,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.darkGrey,
                                width: 4,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
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

  return result; // bu yerda `controller.text` bo‘ladi agar foydalanuvchi "Add New Category" ni bossa
}
