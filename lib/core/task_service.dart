import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _tasksRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  static Future<List<TaskData>> loadTasksForUser(String userId) async {
    final snapshot = await _tasksRef(
      userId,
    ).orderBy('created_at', descending: true).get();

    return snapshot.docs
        .map((doc) => TaskData.fromMap(doc.id, doc.data()))
        .toList();
  }

  static Future<TaskData> addTask(String userId, TaskData task) async {
    final docRef = await _tasksRef(userId).add(task.toMap());
    return task.copyWith(id: docRef.id);
  }

  static Future<void> updateTask(String userId, TaskData task) async {
    if (task.id.isEmpty) return;
    await _tasksRef(userId).doc(task.id).set(task.toMap());
  }

  static Future<void> deleteTask(String userId, String taskId) async {
    if (taskId.isEmpty) return;
    await _tasksRef(userId).doc(taskId).delete();
  }
}
