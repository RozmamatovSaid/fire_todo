import 'package:flutter/material.dart';
import '../../../index.dart';

class AddTaskDropDownButton extends StatefulWidget {
  final Function(int) onCategorySelected;
  final int? initialCategoryId; 

  const AddTaskDropDownButton({
    super.key,
    required this.onCategorySelected,
    this.initialCategoryId,
  });

  @override
  State<AddTaskDropDownButton> createState() => _AddTaskDropDownButtonState();
}

class _AddTaskDropDownButtonState extends State<AddTaskDropDownButton> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategoryId;
    print('DropDown: Initialized with category ID: $selectedCategoryId');

    if (selectedCategoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCategorySelected(selectedCategoryId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadedState && state.categories.isNotEmpty) {
          if (selectedCategoryId == null ||
              !state.categories.any((cat) => cat.id == selectedCategoryId)) {
            selectedCategoryId = state.categories.first.id;
            print(
              'DropDown: Auto-selected first category: $selectedCategoryId',
            );

            // Callback chaqiring
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onCategorySelected(selectedCategoryId!);
            });
          }

          // Selected category mavjudligini tekshiring
          final selectedCategory = state.categories.firstWhere(
            (cat) => cat.id == selectedCategoryId,
            orElse: () => state.categories.first,
          );

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<int>(
              value: selectedCategoryId,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: AppColors.white,
              ),
              dropdownColor: const Color(0xFF2A2A2A),
              items: state.categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategoryId = newValue;
                  });
                  widget.onCategorySelected(newValue);
                  print('DropDown: User selected category: $newValue');
                }
              },
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'No categories',
            style: TextStyle(fontSize: 12, color: AppColors.grey),
          ),
        ); // Empty container if no categories
      },
    );
  }
}
