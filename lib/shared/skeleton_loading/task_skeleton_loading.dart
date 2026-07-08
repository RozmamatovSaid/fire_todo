import 'package:flutter/material.dart';
import 'package:fire_todo/core/constants/app_colors.dart';

class TaskSkeletonLoading extends StatefulWidget {
  const TaskSkeletonLoading({super.key});

  @override
  State<TaskSkeletonLoading> createState() => _TaskSkeletonLoadingState();
}

class _TaskSkeletonLoadingState extends State<TaskSkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedList(
        initialItemCount: 5, // 5 ta skeleton item
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOut)),
            ),
            child: FadeTransition(
              opacity: animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.grey400.withValues(
                              alpha: _animation.value,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.grey400.withValues(
                                  alpha: _animation.value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.grey400.withValues(
                                  alpha: _animation.value,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Container(
                          width: 80,
                          height: 12,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: AppColors.grey400.withValues(
                              alpha: _animation.value,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
