import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Label {
  final String id;
  String name;
  String description;
  bool isDefault;
  int colorIndex;

  Label({
    this.id = '',
    required this.name,
    this.description = '',
    this.isDefault = false,
    this.colorIndex = 0,
  });

  Color get color {
    final index = colorIndex.clamp(0, LabelService.availableColors.length - 1);
    return LabelService.availableColors[index];
  }

  Map<String, dynamic> toMap() {
    return {
      'label_title': name,
      'label_description': description,
      'color_index': colorIndex,
      'default': isDefault,
    };
  }

  factory Label.fromMap(String id, Map<String, dynamic> data) {
    return Label(
      id: id,
      name: data['label_title'] as String? ?? '',
      description: data['label_description'] as String? ?? '',
      colorIndex: data['color_index'] as int? ?? 0,
      isDefault: data['default'] as bool? ?? false,
    );
  }
}

class LabelService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    Label(name: 'Work', isDefault: true, colorIndex: 0),
    Label(name: 'Personal', colorIndex: 4),
    Label(name: 'Shopping', colorIndex: 5),
  ];

  static CollectionReference<Map<String, dynamic>> _labelsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('labels');
  }

  static Future<void> loadLabelsForUser(String userId) async {
    final snapshot = await _labelsRef(userId).get();

    if (snapshot.docs.isEmpty) {
      await _createDefaultLabels(userId);
      return loadLabelsForUser(userId);
    }

    labels = snapshot.docs
        .map((doc) => Label.fromMap(doc.id, doc.data()))
        .toList();

    if (!labels.any((label) => label.isDefault) && labels.isNotEmpty) {
      labels.first.isDefault = true;
      await _labelsRef(userId).doc(labels.first.id).update({'default': true});
    }
  }

  static Future<void> _createDefaultLabels(String userId) async {
    final defaultLabels = [
      Label(name: 'Work', isDefault: true, colorIndex: 0),
      Label(name: 'Personal', colorIndex: 4),
      Label(name: 'Shopping', colorIndex: 5),
    ];

    final batch = _firestore.batch();
    for (final label in defaultLabels) {
      final doc = _labelsRef(userId).doc();
      batch.set(doc, label.toMap());
    }
    await batch.commit();
  }

  static Future<void> addLabel(
    String userId,
    String name,
    bool isDefault,
    int colorIndex,
  ) async {
    if (isDefault) {
      await _clearLabelDefaults(userId);
    }

    final doc = await _labelsRef(userId).add(
      Label(name: name, isDefault: isDefault, colorIndex: colorIndex).toMap(),
    );

    labels.add(
      Label(
        id: doc.id,
        name: name,
        isDefault: isDefault,
        colorIndex: colorIndex,
      ),
    );
  }

  static Future<void> editLabel(
    String userId,
    int index,
    String newName,
    bool isDefault,
    int colorIndex,
  ) async {
    final label = labels[index];
    if (isDefault) {
      await _clearLabelDefaults(userId);
    }

    label.name = newName;
    label.isDefault = isDefault;
    label.colorIndex = colorIndex;

    if (label.id.isNotEmpty) {
      await _labelsRef(userId).doc(label.id).set(label.toMap());
    }
  }

  static Future<void> deleteLabel(String userId, int index) async {
    final label = labels[index];
    if (label.id.isNotEmpty) {
      await _labelsRef(userId).doc(label.id).delete();
    }

    labels.removeAt(index);
    if (!labels.any((label) => label.isDefault) && labels.isNotEmpty) {
      labels[0].isDefault = true;
      final firstId = labels[0].id;
      if (firstId.isNotEmpty) {
        await _labelsRef(userId).doc(firstId).update({'default': true});
      }
    }
  }

  static Future<void> _clearLabelDefaults(String userId) async {
    final batch = _firestore.batch();
    var writeCount = 0;
    for (final label in labels.where(
      (label) => label.isDefault && label.id.isNotEmpty,
    )) {
      batch.update(_labelsRef(userId).doc(label.id), {'default': false});
      label.isDefault = false;
      writeCount++;
    }

    if (writeCount > 0) {
      await batch.commit();
    }
  }

  static String getDefaultLabel() {
    return labels
        .firstWhere((label) => label.isDefault, orElse: () => labels.first)
        .name;
  }
}
