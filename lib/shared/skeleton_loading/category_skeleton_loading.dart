import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CategorySkeletonLoading extends StatefulWidget {
  const CategorySkeletonLoading({super.key});

  @override
  State<CategorySkeletonLoading> createState() =>
      _CategorySkeletonLoadingState();
}

class _CategorySkeletonLoadingState extends State<CategorySkeletonLoading> {
  bool show = true;

  @override
  void initState() {
    super.initState();

    // 3 sekund keyin yashirish
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!show) return SizedBox();

    return Row(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 80 + (index * 15),
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
