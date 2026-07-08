import 'package:fire_todo/core/constants/app_assets.dart';
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
  late final AnimationController _fireController;
  late final AnimationController _glowController;
  late final AnimationController _exitController;

  late final Animation<double> _fireScaleAnimation;
  late final Animation<double> _fireOpacityAnimation;

  late final Animation<double> _glowAnimation;

  late final Animation<double> _exitScaleAnimation;
  late final Animation<double> _exitOpacityAnimation;

  String? _name;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _preloadData();
    _startAnimations();
  }

  void _initAnimations() {
    _fireController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _exitController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fireScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_fireController);

    _fireOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fireController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _exitScaleAnimation = Tween<double>(begin: 1.0, end: 25.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );

    _exitOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  Future<void> _preloadData() async {
    final nameStorage = NameStorageService();
    _name = await nameStorage.getName();
  }

  Future<void> _startAnimations() async {
    _fireController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _glowController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 2200));
    _glowController.stop();
    await _exitController.forward();

    if (!mounted) return;
    context.pushReplacement(
      _name != null ? RouterPaths.home : RouterPaths.entrance,
    );
  }

  @override
  void dispose() {
    _fireController.dispose();
    _glowController.dispose();
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
                child: child,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _fireController,
            builder: (context, child) {
              return Transform.scale(
                scale: _fireScaleAnimation.value,
                child: Opacity(
                  opacity: _fireOpacityAnimation.value,
                  child: child,
                ),
              );
            },
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(
                          alpha: 0.35 * _glowAnimation.value,
                        ),
                        blurRadius: 80 * _glowAnimation.value,
                        spreadRadius: 20 * _glowAnimation.value,
                      ),
                      BoxShadow(
                        color: AppColors.gold.withValues(
                          alpha: 0.15 * _glowAnimation.value,
                        ),
                        blurRadius: 120 * _glowAnimation.value,
                        spreadRadius: 40 * _glowAnimation.value,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Image.asset(
                AppAssets.fireLogo,
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
