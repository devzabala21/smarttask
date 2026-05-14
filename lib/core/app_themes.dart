import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppThemes {
  static const LinearGradient mainBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,

    colors: [
      AppColors.primary, // #FFDDE1
      AppColors.secondary, // #9CD9EE
    ],

    stops: [0.4, 1.0],
  );

  static BoxDecoration secondaryBackground = BoxDecoration(
    color: AppColors.primary,
  );
}
