import 'package:dotted_border/dotted_border.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DottedAddButton extends StatefulWidget {
  const DottedAddButton({
    super.key,
    required this.onTap,
    required this.highlight,
  });

  final VoidCallback onTap;
  final bool highlight;

  @override
  State<DottedAddButton> createState() => _DottedAddButtonState();
}

class _DottedAddButtonState extends State<DottedAddButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _gradientController;
  late Animation<double> _gradientPosition;
  late Animation<double> _pulseAnimation;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _gradientPosition = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.93,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _initialized = true;

    if (widget.highlight) {
      _controller.repeat(reverse: true);
      _gradientController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant DottedAddButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      if (widget.highlight) {
        if (!_controller.isAnimating) {
          _controller.repeat(reverse: true);
        }
        if (!_gradientController.isAnimating) {
          _gradientController.repeat();
        }
      } else {
        if (_controller.isAnimating) {
          _controller.stop();
        }
        if (_gradientController.isAnimating) {
          _gradientController.stop();
        }
      }
    }
  }

  @override
  void dispose() {
    if (_initialized) {
      _controller.dispose();
      _gradientController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(39),
          highlightColor: Colors.white.withOpacity(0.3),
          splashColor: Colors.white.withOpacity(0.2),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: [6, 3],
              strokeWidth: 1.5,
              color: AppColors.grey500,
              radius: const Radius.circular(39),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(39),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(39),
        highlightColor: Colors.white.withOpacity(0.3),
        splashColor: Colors.white.withOpacity(0.2),
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _gradientController]),
          builder: (context, child) {
            return Transform.scale(
              scale: widget.highlight ? _pulseAnimation.value : 1.0,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  dashPattern: [6, 3],
                  strokeWidth: 1.5,
                  color: AppColors.grey500,
                  radius: const Radius.circular(39),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 29,
                    vertical: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(39),
                    gradient: widget.highlight
                        ? LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                            ],
                            stops: [
                              (_gradientPosition.value - 0.3).clamp(0.0, 1.0),
                              _gradientPosition.value.clamp(0.0, 1.0),
                              (_gradientPosition.value + 0.3).clamp(0.0, 1.0),
                            ],
                          )
                        : null,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
