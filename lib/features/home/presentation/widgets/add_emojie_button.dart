// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/core/constants/emojies.dart';
import 'package:fire_todo/shared/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';

// ignore: must_be_immutable
class EmojiPickerBottomSheet extends StatefulWidget {
  Function(String emojiSelected) onEmojiSelected;

  EmojiPickerBottomSheet({super.key, required this.onEmojiSelected});

  @override
  _EmojiPickerBottomSheetState createState() => _EmojiPickerBottomSheetState();
}

class _EmojiPickerBottomSheetState extends State<EmojiPickerBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final selectedCategoryIndex = ValueNotifier<int>(0);
  final selectEmojiNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: EmojiCategories.categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    selectedCategoryIndex.dispose();
    selectEmojiNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title and close button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 24),
                ),
                Text(
                  AppStrings.addNewCategory.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),

          // Category title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.categoryType.tr(),
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Category tabs
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder(
              valueListenable: selectedCategoryIndex,
              builder: (context, selectedIndex, child) => TabBar(
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                isScrollable: true,
                indicator: const BoxDecoration(),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                onTap: (index) {
                  selectedCategoryIndex.value = index;
                },

                tabs: EmojiCategories.categories.map((category) {
                  int index = EmojiCategories.categories.indexOf(category);
                  bool isSelected = selectedIndex == index;

                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gold : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      color: isSelected ? AppColors.background : AppColors.grey,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder(
                valueListenable: selectedCategoryIndex,
                builder: (context, selectedIndex, child) => Text(
                  EmojiCategories.categories[selectedIndex].name.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueListenableBuilder(
                valueListenable: selectedCategoryIndex,
                builder: (context, selectedIndex, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0.3, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                              child: child,
                            ),
                          );
                        },
                    child: GridView.builder(
                      key: ValueKey(selectedIndex),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: EmojiCategories
                          .categories[selectedIndex]
                          .emojis
                          .length,
                      itemBuilder: (context, index) {
                        String emoji = EmojiCategories
                            .categories[selectedIndex]
                            .emojis[index];

                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value,
                                child: Material(
                                  child: InkWell(
                                    splashColor: AppColors.gold.withValues(
                                      alpha: 0.5,
                                    ),
                                    highlightColor: AppColors.gold,
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      selectEmojiNotifier.value = emoji;
                                      widget.onEmojiSelected(emoji);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          emoji,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: selectEmojiNotifier,
            builder: (context, selectEmoji, child) => AppButton(
              text: "${selectEmoji ?? ''}  ${AppStrings.add.tr()}",
              padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showEmojiPicker(
  BuildContext context,
  Function(String emoji) onEmojiSelected,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        EmojiPickerBottomSheet(onEmojiSelected: onEmojiSelected),
  );
}
