import 'package:flutter/material.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/global_image.dart';

class AddTaskSelectFlag extends StatefulWidget {
  const AddTaskSelectFlag({super.key, required this.onFlagSelected});

  final Function(int index) onFlagSelected;

  @override
  State<AddTaskSelectFlag> createState() => _AddTaskSelectFlagState();
}

class _AddTaskSelectFlagState extends State<AddTaskSelectFlag> {
  int initialFlagIndex = 0;

  final List<String> flags = [
    AppAssets.flagYellow, // 0 - medium
    AppAssets.flagGreen, // 2 - low
    AppAssets.flagRed, // 3 - urgent
  ];

  late int currentFlagIndex;

  @override
  void initState() {
    super.initState();
    currentFlagIndex = initialFlagIndex;
  }

  void _selectNextFlag() {
    setState(() {
      currentFlagIndex = (currentFlagIndex + 1) % flags.length;
    });
    widget.onFlagSelected(currentFlagIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectNextFlag,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: GlobalImage(flags[currentFlagIndex], width: 24, height: 24),
      ),
    );
  }
}
