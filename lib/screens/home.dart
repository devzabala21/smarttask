import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/auth_service.dart';
import '../core/label_service.dart';
import '../widgets/app_btn_cat.dart';
import '../widgets/app_btn_add.dart';
import '../widgets/add_task_modal.dart';
import '../widgets/side_menu.dart';
import '../widgets/app_task_card.dart';
import 'archive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class CategoryItem {
  final String name;
  final int count;

  CategoryItem(this.name, this.count);
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String selectedCategory = "All";

  late AnimationController _menuController;

  List<TaskData> get filteredTasks {
    if (selectedCategory == "All") return _tasks;
    return _tasks.where((task) => task.label == selectedCategory).toList();
  }

  List<CategoryItem> get categories {
    List<CategoryItem> cats = [CategoryItem("All", _tasks.length)];
    for (var label in LabelService.labels) {
      int count = _tasks.where((task) => task.label == label.name).length;
      cats.add(CategoryItem(label.name, count));
    }
    return cats;
  }

  final List<TaskData> _tasks = [
    TaskData(
      title: 'Sample Task Title',
      description: 'This is a brief description of the task.',
      label: 'Work',
    ),
    TaskData(
      title: 'Weekly Review',
      description: 'Review your notes and update your project plan.',
      label: 'Personal',
    ),
  ];

  final List<TaskData> _archivedTasks = [];

  Future<void> _openAddTaskDialog() async {
    final TaskData? newTask = await showAddTaskDialog(context);
    if (newTask != null) {
      setState(() {
        _tasks.insert(0, newTask);
      });
    }
  }

  Future<void> _editTask(TaskData task) async {
    final TaskData? updatedTask = await showEditTaskDialog(context, task);
    if (updatedTask != null) {
      setState(() {
        final index = _tasks.indexOf(task);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
      });
    }
  }

  Future<void> _archiveTask(TaskData task) async {
    final bool? confirm = await _showArchiveConfirmationDialog();
    if (confirm == true) {
      setState(() {
        _tasks.remove(task);
        _archivedTasks.add(task);
      });
    }
  }

  Future<bool?> _showArchiveConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            'Move to Archive?',
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
              'This task will be moved to your archive.',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 16,
                color: AppColors.grey,
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
                    side: const BorderSide(color: AppColors.accentDark),
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
                      color: AppColors.accentDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentDark,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Archive',
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

  void _goToArchive() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArchiveScreen(
          archivedTasks: _archivedTasks,
          onRestore: (task) {
            setState(() {
              _archivedTasks.remove(task);
              _tasks.insert(0, task);
            });
          },
        ),
      ),
    );
  }

  Future<String?> _showLabelSelectionDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: AppColors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Labels',
                      style: TextStyle(
                        fontFamily: 'Aclonica',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select a label for the task.',
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
              // Labels Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: LabelService.labels.map((label) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(label.name),
                      child: IntrinsicWidth(
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 36),
                          decoration: BoxDecoration(
                            color: label.color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          alignment: Alignment.center,
                          child: Text(
                            label.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13),
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
  }

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_menuController.isCompleted) {
      _menuController.reverse();
    } else {
      _menuController.forward();
    }
  }

  Color _labelColorFor(String labelName) {
    final label = LabelService.labels.firstWhere(
      (label) => label.name == labelName,
      orElse: () => LabelService.labels.first,
    );
    return label.color;
  }

  @override
  Widget build(BuildContext context) {
    final String username = AuthService.currentUser?.username ?? "Guest";
    final String bio = AuthService.currentUser?.bio ?? "My Tasks";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Main Content Layer
          RepaintBoundary(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 15),
                  color: AppColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                AuthService.currentUser?.avatarPath ?? AuthService.avatarOptions.first,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, $username!",
                                  style: const TextStyle(
                                    fontFamily: 'Aclonica',
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  bio,
                                  style: const TextStyle(
                                    fontFamily: 'Aclonica',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Burger Menu Button
                            IconButton(
                              onPressed: _toggleMenu,
                              icon: const Icon(
                                Icons.menu,
                                color: AppColors.primaryAccent,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Swipeable Category Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: AppBtnCat(
                                  label: cat.name,
                                  checker: cat.count,
                                  isSelected: selectedCategory == cat.name,
                                  onTap: () => setState(
                                    () => selectedCategory = cat.name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Task List Area
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AppTaskCard(
                          statusTag: task.statusTag,
                          title: task.title,
                          description: task.description,
                          labelName: task.label,
                          labelColor: _labelColorFor(task.label),
                          onEdit: () => _editTask(task),
                          onDelete: () => _archiveTask(task),
                          onAction: () async {
                            final selectedLabel =
                                await _showLabelSelectionDialog();
                            if (selectedLabel != null) {
                              setState(() {
                                final taskIndex = _tasks.indexOf(task);
                                _tasks[taskIndex] = TaskData(
                                  title: task.title,
                                  description: task.description,
                                  label: selectedLabel,
                                );
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          //Add Button
          Positioned(
            right: 30,
            bottom: 45 + MediaQuery.of(context).padding.bottom,
            child: AppBtnAdd(onPressed: _openAddTaskDialog),
          ),

          //Side Menu Overlay Layer
          SideMenuOverlay(
            animation: _menuController,
            onClose: _toggleMenu,
            onArchiveTap: _goToArchive,
            onProfileUpdated: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}
