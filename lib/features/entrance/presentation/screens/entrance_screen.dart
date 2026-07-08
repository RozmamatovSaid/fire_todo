import 'package:easy_localization/easy_localization.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/core/router/router_paths.dart';
import 'package:fire_todo/features/main/data/datasource/name_storage_service.dart';
import 'package:fire_todo/shared/extensions/gap.dart';
import 'package:fire_todo/shared/widgets/app_button.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class EntranceScreen extends StatelessWidget {
  EntranceScreen({super.key});
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 56),
                      GlobalText(
                        AppStrings.whatIsYourName,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.g,
                      GlobalText(
                        AppStrings.enterNameSubtitle,
                        color: AppColors.grey300,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 82),
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.name,
                          cursorColor: AppColors.white,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: AppStrings.enterYourName.tr(),
                            hintStyle: const TextStyle(
                              color: AppColors.grey500,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.grey500,
                                width: 2,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            border: const UnderlineInputBorder(),
                            contentPadding: const EdgeInsets.only(bottom: 8),
                          ),
                        ),
                      ),

                      const Spacer(),
                      ListenableBuilder(
                        listenable: controller,
                        builder: (context, child) {
                          return AppButton(
                            text: AppStrings.getStartedButton.tr(),
                            isEnable: controller.text.isNotEmpty,
                            onPressed: () async {
                              final nameService = NameStorageService();
                              await nameService.saveName(controller.text);
                              // ignore: use_build_context_synchronously
                              context.go(RouterPaths.home);
                            },
                          );
                        },
                      ),
                      24.g,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
