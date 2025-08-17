import 'package:dotted_border/dotted_border.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/router/router_paths.dart';
import 'package:fire_todo/features/main/data/datasource/name_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _strikeController;
  late final AnimationController _exitController;

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoOpacityAnimation;
  late final Animation<double> _dottedBorderOpacityAnimation;

  late final Animation<double> _textOpacityAnimation;
  late final Animation<Offset> _textSlideAnimation;

  late final Animation<double> _strikeAnimation;

  late final Animation<double> _exitScaleAnimation;
  late final Animation<double> _exitOpacityAnimation;

  late final String? _name; // ✅ oldindan yuklanadigan ism

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _preloadData();
    _startAnimations();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _strikeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _exitController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _dottedBorderOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _strikeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _strikeController, curve: Curves.easeInOut),
    );

    _exitScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInBack),
    );

    _exitOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
  }

  void _preloadData() async {
    final nameStorage = NameStorageService();
    _name = await nameStorage.getName(); // ✅ diskdan oldincha o‘qib olamiz
  }

  Future<void> _startAnimations() async {
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    _strikeController.forward();

    await Future.delayed(const Duration(milliseconds: 3000));
    await _exitController.forward();

    if (!mounted) return;
    context.pushReplacement(
      _name != null ? RouterPaths.home : RouterPaths.entrance,
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _strikeController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _exitController,
          builder: (context, child) {
            return Transform.scale(
              scale: _exitScaleAnimation.value,
              child: Opacity(
                opacity: _exitOpacityAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _dottedBorderOpacityAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity:
                                          _dottedBorderOpacityAnimation.value,
                                      child: DottedBorder(
                                        options: CircularDottedBorderOptions(
                                          color: AppColors.white,
                                          borderPadding: const EdgeInsets.all(
                                            -3,
                                          ),
                                          dashPattern: const [4.4],
                                        ),
                                        child: Container(
                                          width: 108,
                                          height: 108,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 108,
                                  height: 108,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.purple,
                                  ),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 6,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlideAnimation,
                          child: FadeTransition(
                            opacity: _textOpacityAnimation,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _strikeAnimation,
                                  builder: (context, child) {
                                    return Stack(
                                      children: [
                                        const Text(
                                          "To-Do",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            height: 32 / 24,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              height: 2,
                                              width:
                                                  _strikeAnimation.value * 62,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Planer",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 32 / 24,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
