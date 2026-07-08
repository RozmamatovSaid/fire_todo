import 'package:easy_localization/easy_localization.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/constants/app_fonts.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/core/injection/dp_injection.dart';
import 'package:fire_todo/features/home/domain/repository/category_repository.dart';
import 'package:fire_todo/features/home/domain/repository/task_repository.dart';
import 'package:fire_todo/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:fire_todo/features/home/presentation/bloc/tasks/task_bloc.dart';
import 'package:fire_todo/shared/dialogs/coming_soon.dart';
import 'package:fire_todo/shared/widgets/action_button.dart';
import 'package:fire_todo/shared/widgets/global_image.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:fire_todo/shared/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

mixin SettingsScreenMixin {
  Future<void> showEditNameDialog(BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.grey700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const GlobalText(
                  AppStrings.editYourName,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  cursorColor: AppColors.gold,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: AppStrings.enterNewName.tr(),
                    hintStyle: const TextStyle(color: AppColors.grey400),
                    filled: true,
                    fillColor: AppColors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: AppStrings.save.tr(),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    final newName = controller.text.trim();
                    if (newName.isNotEmpty) {
                      context.read<SettingsCubit>().updateUsername(newName);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleRateUs(BuildContext context) {
    showComingSoonDialog(context);
  }

  void handlePolicy(BuildContext context) {
    showComingSoonDialog(context);
  }

  void handleShare(BuildContext context) {
    SharePlus.instance.share(ShareParams(text: 'Check out FIRE TODO app!'));
  }

  void handleMore(BuildContext context) {
    showComingSoonDialog(context);
  }
}

class SettingsScreen extends StatelessWidget with SettingsScreenMixin {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        taskBloc: context.read<TaskBloc>(),
        categoryBloc: context.read<CategoryBloc>(),
        categoryRepository: getIt<CategoryRepository>(),
        taskRepository: getIt<TaskRepository>(),
      )..init(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget with SettingsScreenMixin {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.successMessage != curr.successMessage ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!.tr()),
              backgroundColor: AppColors.purple,
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!.tr()),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(
                      icon: AppAssets.arrowLeft,
                      onTap: () => context.pop(),
                    ),
                    GlobalText(
                      AppStrings.settings,
                      fontSize: 24,
                      fontFamily: AppFonts.roboto,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildProfileCard(state),
                        const SizedBox(height: 32),
                        const GlobalText(
                          AppStrings.customize,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          iconPath: AppAssets.edit,
                          titleKey: AppStrings.editYourName,
                          onTap: () =>
                              showEditNameDialog(context, state.username),
                        ),
                        const SizedBox(height: 20),
                        _buildNotificationItem(context, state),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          iconPath: AppAssets.import,
                          titleKey: AppStrings.importData,
                          onTap: () => context.read<SettingsCubit>().importData(),
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          iconPath: AppAssets.export,
                          titleKey: AppStrings.exportData,
                          onTap: () => context.read<SettingsCubit>().exportData(),
                        ),
                        const SizedBox(height: 48),
                        Center(
                          child: GlobalText(
                            "${AppStrings.version.tr()}: 0.10.10",
                            fontSize: 14,
                            color: AppColors.grey400,
                            useTranslation: false,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(
                          color: AppColors.grey500.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                        const SizedBox(height: 24),
                        _buildBottomRow(context),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(SettingsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.purple,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                AppAssets.female,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  state.username,
                  fontSize: 20,
                  fontFamily: AppFonts.recoleta,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  useTranslation: false,
                ),
                const SizedBox(height: 4),
                GlobalText(
                  state.joinDate,
                  fontSize: 14,
                  color: AppColors.grey300,
                  useTranslation: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String titleKey,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.grey700,
              shape: BoxShape.circle,
            ),
            child: GlobalImage(iconPath, color: AppColors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GlobalText(
              titleKey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, SettingsState state) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.grey700,
            shape: BoxShape.circle,
          ),
          child: const GlobalImage(
            AppAssets.notificationBing,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: GlobalText(
            AppStrings.notification,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        CupertinoSwitch(
          activeTrackColor: AppColors.purple,
          value: state.notificationEnabled,
          onChanged: (value) =>
              context.read<SettingsCubit>().toggleNotifications(value),
        ),
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBottomButton(
          context: context,
          iconPath: AppAssets.star,
          labelKey: AppStrings.rateUs,
          onTap: () => handleRateUs(context),
        ),
        _buildBottomButton(
          context: context,
          iconData: Icons.description_outlined,
          labelKey: AppStrings.policy,
          onTap: () => handlePolicy(context),
        ),
        _buildBottomButton(
          context: context,
          iconPath: AppAssets.share,
          labelKey: AppStrings.share,
          onTap: () => handleShare(context),
        ),
        _buildBottomButton(
          context: context,
          iconPath: AppAssets.more,
          labelKey: AppStrings.more,
          onTap: () => handleMore(context),
        ),
      ],
    );
  }

  Widget _buildBottomButton({
    required BuildContext context,
    String? iconPath,
    IconData? iconData,
    required String labelKey,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.purple,
                width: 1.5,
              ),
            ),
            child: iconPath != null
                ? GlobalImage(
                    iconPath,
                    color: iconPath == AppAssets.more ? null : AppColors.white,
                  )
                : Icon(iconData, color: AppColors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        GlobalText(
          labelKey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.grey300,
        ),
      ],
    );
  }
}
