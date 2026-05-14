import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/app_colors.dart';
import '../core/label_service.dart';
import '../models/task_model.dart';

class ArchiveScreen extends StatefulWidget {
  final List<TaskData> archivedTasks;
  final Function(TaskData) onRestore;

  const ArchiveScreen({
    super.key,
    required this.archivedTasks,
    required this.onRestore,
  });

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  late List<TaskData> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.archivedTasks);
  }

  Color? _labelColorFor(String labelName) {
    try {
      final label = LabelService.labels.firstWhere(
        (label) => label.name == labelName,
      );
      return label.color;
    } catch (_) {
      return null;
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(String taskTitle) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            'Delete Task?',
            style: TextStyle(
              fontFamily: 'Aclonica',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This task will be deleted permanently.',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryAccent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Archive',
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No archived tasks',
                        style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E8EA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      final badgeColor = _labelColorFor(
                                        task.statusTag,
                                      );
                                      return Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 36,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              badgeColor ??
                                              const Color(0xFFDADDE0),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          task.statusTag,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Lora',
                                            fontSize: 14,
                                            color: badgeColor != null
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.arrow_counterclockwise,
                                      size: 22,
                                      color: AppColors.primaryAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _tasks.removeAt(index);
                                        widget.onRestore(task);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                task.title,
                                style: const TextStyle(
                                  fontFamily: 'Lora',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    CupertinoIcons.list_bullet,
                                    size: 22,
                                    color: AppColors.primaryAccent,
                                  ),
                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final confirm =
                                            await _showDeleteConfirmationDialog(
                                              task.title,
                                            );
                                        if (confirm == true) {
                                          setState(() {
                                            _tasks.removeAt(index);
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                      ),
                                      child: const Text(
                                        'Delete',
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
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
