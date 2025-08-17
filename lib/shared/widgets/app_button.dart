import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Duration? loadingDuration;
  final bool isLoading;
  final double borderRadius;
  final double height, width;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final bool isEnable;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFF9B60F7),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.loadingDuration,
    this.isLoading = false,
    this.borderRadius = 16,
    this.height = 48,
    this.padding,
    this.icon,
    this.isEnable = true,
    this.width = double.infinity,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isPressedNotifier;
  late ValueNotifier<bool> _isInternalLoadingNotifier;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isPressedNotifier = ValueNotifier<bool>(false);
    _isInternalLoadingNotifier = ValueNotifier<bool>(false);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _isPressedNotifier.dispose();
    _isInternalLoadingNotifier.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    // Faqat isEnable true bo'lganda ishlaydi
    if (!widget.isEnable ||
        _isInternalLoadingNotifier.value ||
        widget.isLoading)
      return;

    if (widget.onPressed != null) {
      // Bosish animatsyasi boshlash
      _isPressedNotifier.value = true;
      await _animationController.forward();

      // Kichik pauza
      await Future.delayed(const Duration(milliseconds: 50));

      // Animatsyani qaytarish
      await _animationController.reverse();
      _isPressedNotifier.value = false;

      if (widget.loadingDuration != null) {
        _isInternalLoadingNotifier.value = true;
        widget.onPressed!();
        await Future.delayed(widget.loadingDuration!);
        _isInternalLoadingNotifier.value = false;
      } else {
        widget.onPressed!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isInternalLoadingNotifier,
      builder: (context, isInternalLoading, child) {
        final isLoading = isInternalLoading || widget.isLoading;

        final currentBackgroundColor = widget.isEnable
            ? widget.backgroundColor
            : const Color(0xFF202020);

        final currentTextColor = widget.isEnable
            ? widget.textColor
            : widget.textColor.withValues(alpha: 0.6);

        return Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 32),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isPressedNotifier,
            builder: (context, isPressed, child) {
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isPressed && widget.isEnable
                        ? _scaleAnimation.value
                        : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: widget.height,
                      width: widget.width,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? currentBackgroundColor.withOpacity(0.7)
                            : currentBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        boxShadow: isPressed || !widget.isEnable
                            ? []
                            : [
                                BoxShadow(
                                  color: currentBackgroundColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.isEnable && !isLoading
                              ? _handleTap
                              : null,
                          splashColor: widget.isEnable
                              ? Colors.white.withOpacity(0.1)
                              : Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  currentTextColor,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Yuklanmoqda...',
                                          style: TextStyle(
                                            color: currentTextColor,
                                            fontSize: widget.fontSize,
                                            fontWeight: widget.fontWeight,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (widget.icon != null) ...[
                                          widget.icon!,
                                          const SizedBox(width: 8),
                                        ],
                                        Text(
                                          widget.text,
                                          style: TextStyle(
                                            color: currentTextColor,
                                            fontSize: widget.fontSize,
                                            fontWeight: widget.fontWeight,
                                          ),
                                        ),
                                      ],
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
    );
  }
}
