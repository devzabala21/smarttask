import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/app_colors.dart';

class AppTaskCard extends StatelessWidget {
  final String statusTag;
  final String title;
  final String description;
  final String? labelName;
  final Color? labelColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAction;

  const AppTaskCard({
    super.key,
    required this.statusTag,
    required this.title,
    required this.description,
    this.labelName,
    this.labelColor,
    this.onEdit,
    this.onDelete,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status Tag
              Container(
                constraints: const BoxConstraints(minHeight: 36),
                decoration: BoxDecoration(
                  color: labelColor ?? AppColors.tagBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                child: Text(
                  statusTag,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 14,
                    color: labelColor != null
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              ),
              const Spacer(),
              // Top Action Icons
              IconButton(
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  CupertinoIcons.square_pencil_fill,
                  size: 22,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  CupertinoIcons.trash_fill,
                  size: 22,
                  color: AppColors.primaryAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Task Contents
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.list_bullet,
                    size: 22,
                    color: AppColors.primaryAccent,
                  ),
                ],
              ),

              // Mark As
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonAccent,
                    foregroundColor: AppColors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text(
                    "Mark As",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
