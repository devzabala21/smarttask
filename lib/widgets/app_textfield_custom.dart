import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppTxtFldCustom extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController? controller;
  final int? maxLength;
  final Function(String)? onChanged;

  const AppTxtFldCustom({
    super.key,
    required this.label,
    this.obscureText = false,
    this.controller,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLength: maxLength,
      onChanged: onChanged,

      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),

      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(fontFamily: 'Inter', color: Colors.grey),
        counterText: maxLength != null ? '' : null,

        filled: true,
        fillColor: Colors.white,

        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.secondaryAccent),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
