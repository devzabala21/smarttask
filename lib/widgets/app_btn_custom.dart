import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';

class AppBtnCustom extends StatelessWidget {
  final String label;
  final VoidCallback ? onPressed;
  final Color? color;
  final Color? textColor;
  final String? iconPath;

  const AppBtnCustom({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
    this.iconPath,
  });

@override
Widget build(BuildContext context) {
  final bool hasIcon = iconPath != null;

  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryAccent,
        foregroundColor: textColor ?? Colors.white,
        elevation: 0,
        padding: EdgeInsets.zero, 
        textStyle: const TextStyle(
          inherit: true,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: color == Colors.white 
              ? const BorderSide(color: Colors.black12) 
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Padding(

        padding: EdgeInsets.only(
          left: hasIcon ? 70 : 0, 
          right: hasIcon ? 10 : 0,
        ),

        child: Row(
          mainAxisAlignment: hasIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            if (hasIcon) ...[
              SvgPicture.asset(
                iconPath!,
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 16),
            ],
            
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  
}