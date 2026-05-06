import 'package:flutter/material.dart';
import '../core/label_service.dart';
import '../core/app_colors.dart';

class TaskData {
  final String title;
  final String description;
  final String statusTag;
  final String label;

  TaskData({
    required this.title,
    required this.description,
    String? statusTag,
    this.label = '',
  }) : statusTag = label.isNotEmpty ? label : (statusTag ?? 'To Do');
}

Future<TaskData?> showAddTaskDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  return showDialog<TaskData>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      bool isValid = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: AppColors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Add New Task',
                            style: TextStyle(
                              fontFamily: 'Aclonica',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a new task by filling out the form below.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title Label with Red Asterisk
                    Row(
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isValid)
                          const Text(
                            ' *',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    TextField(
                      controller: titleController,
                      maxLength: 32, // Hard limit of 32 characters
                      onChanged: (value) {
                        setState(() {
                          // Valid if length is between 4 and 32
                          isValid =
                              value.trim().length >= 4 &&
                              value.trim().length <= 32;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter task title (4-32 chars)',
                        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                        counterText:
                            "", // Hide the default counter if you want it cleaner
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.accentDark,
                    ),
                    const SizedBox(height: 24),

                    // Description Label and Expanding Input
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      minLines: 1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter task description (optional)',
                        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.accentDark,
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentDark,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: isValid
                                ? () {
                                    Navigator.of(context).pop(
                                      TaskData(
                                        title: titleController.text.trim(),
                                        description: descriptionController.text
                                            .trim(),
                                        label: LabelService.getDefaultLabel(),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isValid
                                  ? AppColors.accentDark
                                  : AppColors.accentLighter,
                              disabledBackgroundColor: AppColors.accentLighter.withOpacity(0.5),
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: const Text(
                              'Add Task',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<TaskData?> showEditTaskDialog(BuildContext context, TaskData task) {
  final TextEditingController titleController = TextEditingController(
    text: task.title,
  );
  final TextEditingController descriptionController = TextEditingController(
    text: task.description,
  );

  return showDialog<TaskData>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      bool isValid =
          task.title.trim().length >= 4 && task.title.trim().length <= 32;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: AppColors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Edit Task',
                            style: TextStyle(
                              fontFamily: 'Aclonica',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Update the task details below.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isValid)
                          const Text(
                            ' *',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    TextField(
                      controller: titleController,
                      maxLength: 32,
                      onChanged: (value) {
                        setState(() {
                          isValid =
                              value.trim().length >= 4 &&
                              value.trim().length <= 32;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter task title (4-32 chars)',
                        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.accentDark,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      minLines: 1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter task description (optional)',
                        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accentDark,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.accentDark,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentDark,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: isValid
                                ? () {
                                    Navigator.of(context).pop(
                                      TaskData(
                                        title: titleController.text.trim(),
                                        description: descriptionController.text
                                            .trim(),
                                        label: task.label,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isValid
                                  ? AppColors.accentDark
                                  : AppColors.accentLighter,
                              disabledBackgroundColor: AppColors.accentLighter.withOpacity(0.5),
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
