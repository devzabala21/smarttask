import 'dart:ui';
import 'package:flutter/material.dart';

class AppLogoCustom extends StatelessWidget {
  final double size;

  const AppLogoCustom({super.key, this.size = 150.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(0, 8),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Image.asset(
              'assets/icons/icon_logo.png',
              height: size,
              width: size,
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ),
        ),
        Image.asset('assets/icons/icon_logo.png', height: size, width: size),
      ],
    );
  }
}
