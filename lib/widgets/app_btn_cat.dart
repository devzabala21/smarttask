import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppBtnCat extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int checker;

  const AppBtnCat({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
    this.checker = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent : AppColors.accentLight,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            checker > 0 ? '$label ($checker)' : label,
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Lora',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
