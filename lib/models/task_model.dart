import 'package:cloud_firestore/cloud_firestore.dart';

class TaskData {
  final String id;
  final String title;
  final String description;
  final String label;
  final String labelId;
  final DateTime createdAt;
  final bool archived;

  TaskData({
    this.id = '',
    required this.title,
    required this.description,
    this.label = '',
    this.labelId = '',
    DateTime? createdAt,
    this.archived = false,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskData copyWith({
    String? id,
    String? title,
    String? description,
    String? label,
    String? labelId,
    DateTime? createdAt,
    bool? archived,
  }) {
    return TaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      label: label ?? this.label,
      labelId: labelId ?? this.labelId,
      createdAt: createdAt ?? this.createdAt,
      archived: archived ?? this.archived,
    );
  }

  String get statusTag => label.isNotEmpty ? label : 'To Do';

  Map<String, dynamic> toMap() {
    return {
      'task_title': title,
      'task_description': description,
      'label_title': label,
      'label_id': labelId,
      'created_at': Timestamp.fromDate(createdAt),
      'archived': archived,
    };
  }

  factory TaskData.fromMap(String id, Map<String, dynamic> data) {
    final createdAtValue = data['created_at'];
    DateTime parsedCreatedAt;

    if (createdAtValue is Timestamp) {
      parsedCreatedAt = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      parsedCreatedAt = createdAtValue;
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return TaskData(
      id: id,
      title: data['task_title'] as String? ?? '',
      description: data['task_description'] as String? ?? '',
      label: data['label_title'] as String? ?? '',
      labelId: data['label_id'] as String? ?? '',
      createdAt: parsedCreatedAt,
      archived: data['archived'] as bool? ?? false,
    );
  }
}
