import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/label_service.dart';
import '../widgets/app_btn_add.dart';

class LabelScreen extends StatefulWidget {
  const LabelScreen({super.key});

  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {
  void _openAddLabelDialog() async {
    final result = await showAddLabelDialog(context);
    if (result != null) {
      setState(() {
        LabelService.addLabel(result['name'], result['isDefault'], result['color']);
      });
    }
  }

  void _editLabel(int index) async {
    final label = LabelService.labels[index];
    final result = await showAddLabelDialog(
      context,
      initialName: label.name,
      initialDefault: label.isDefault,
      initialColor: label.color,
    );
    if (result != null) {
      setState(() {
        LabelService.editLabel(
          index,
          result['name'],
          result['isDefault'],
          result['color'],
        );
      });
    }
  }

  void _deleteLabel(int index) async {
    final label = LabelService.labels[index];
    final result = await showDeleteConfirmationDialog(context, label.name);
    if (result == true) {
      setState(() {
        LabelService.deleteLabel(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primaryAccent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Labels',
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
              child: ListView.builder(
                itemCount: LabelService.labels.length,
                itemBuilder: (context, index) {
                  final label = LabelService.labels[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            label.isDefault ? '*' : '',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          constraints: const BoxConstraints(minHeight: 36),
                          decoration: BoxDecoration(
                            color: label.color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          alignment: Alignment.center,
                          child: Text(
                            label.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editLabel(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteLabel(index),
                              ),
                            ],
                          ),
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
      floatingActionButton: AppBtnAdd(onPressed: _openAddLabelDialog),
    );
  }
}

Future<Map<String, dynamic>?> showAddLabelDialog(
  BuildContext context, {
  String? initialName,
  bool? initialDefault,
  Color? initialColor,
}) {
  final TextEditingController nameController = TextEditingController(
    text: initialName,
  );
  bool isDefault = initialDefault ?? false;
  Color selectedColor = initialColor ?? LabelService.availableColors[0];
  bool isValid =
      initialName != null &&
      initialName.length >= 4 &&
      initialName.length <= 16;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            initialName == null ? 'Add New Label' : 'Edit Label',
            style: const TextStyle(
              fontFamily: 'Aclonica',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              maxLength: 16,
              decoration: const InputDecoration(
                labelText: 'Label Name',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
              onChanged: (value) {
                setState(() {
                  isValid = value.length >= 4 && value.length <= 16;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Color',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: LabelService.availableColors.map((color) {
                final isSelected = selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Set as default',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: isValid
                ? () => Navigator.of(context).pop({
                      'name': nameController.text.trim(),
                      'isDefault': isDefault,
                      'color': selectedColor,
                    })
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              initialName == null ? 'Add' : 'Save',
              style: const TextStyle(
                fontFamily: 'Lora',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> showDeleteConfirmationDialog(
  BuildContext context,
  String labelName,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          'Delete Label',
          style: const TextStyle(
            fontFamily: 'Aclonica',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      content: Text(
        'Are you sure you want to delete "$labelName"?',
        style: const TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Lora',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(
              fontFamily: 'Lora',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
