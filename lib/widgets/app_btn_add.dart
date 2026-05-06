import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppBtnAdd extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBtnAdd({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primaryAccent,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 35),
    );
  }
}