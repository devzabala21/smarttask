import 'package:flutter/material.dart';
import '../widgets/app_logo_custom.dart';
import '../router/app_router.dart';
import '../core/app_themes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), 
    );

    //Fall
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -3.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        
        curve: const Interval(0.0, 0.2, curve: Curves.linear),
      ),
    );

    // Flip
  _rotateAnimation = TweenSequence<double>([
    
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: 0.5).chain(CurveTween(curve: Curves.linear)),
      weight: 15, 
    ),
    
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.easeOutQuart)),
      weight: 85, 
    ),
  ]).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 1.0), 
    ),
  );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });

    FlutterNativeSplash.remove();

    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  void _navigateToHome() {
    // Check if the widget is still in the tree before navigating
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: double.infinity, 
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppThemes.mainBackground,
        ),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: AnimatedBuilder(
              animation: _rotateAnimation,
              builder: (context, child) {
                final double angle = _rotateAnimation.value * 2 * 3.14159;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) 
                    ..rotateY(angle),      
                  child: const AppLogoCustom(size: 200),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}