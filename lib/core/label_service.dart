import 'package:flutter/material.dart';

class Label {
  String name;
  bool isDefault;
  Color color;

  Label({
    required this.name,
    this.isDefault = false,
    this.color = const Color(0xFF6D0339),
  });
}

class LabelService {
  static final List<Color> availableColors = [
    const Color(0xFF6D0339), // Primary Accent
    const Color(0xFFFF1744), // Red
    const Color(0xFFFF5722), // Orange
    const Color(0xFFFFC107), // Yellow
    const Color(0xFF4CAF50), // Green
    const Color(0xFF2196F3), // Blue
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFE91E63), // Pink
  ];

  static List<Label> labels = [
    Label(name: 'Work', isDefault: true, color: const Color(0xFF6D0339)),
    Label(name: 'Personal', color: const Color(0xFF4CAF50)),
    Label(name: 'Shopping', color: const Color(0xFF2196F3)),
  ];

  static String getDefaultLabel() {
    return labels
        .firstWhere((label) => label.isDefault, orElse: () => labels.first)
        .name;
  }

  static void addLabel(String name, bool isDefault, Color color) {
    if (isDefault) {
      for (var label in labels) {
        label.isDefault = false;
      }
    }
    labels.add(Label(name: name, isDefault: isDefault, color: color));
  }

  static void editLabel(
    int index,
    String newName,
    bool isDefault,
    Color color,
  ) {
    if (isDefault) {
      for (var label in labels) {
        label.isDefault = false;
      }
    }
    labels[index].name = newName;
    labels[index].isDefault = isDefault;
    labels[index].color = color;
  }

  static void deleteLabel(int index) {
    labels.removeAt(index);
  }
}
