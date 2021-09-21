import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:minhas_tarefas/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> allTasks = [];
  List<Task> toDoTasks = [];
  List<Task> doingTasks = [];
  List<Task> doneTasks = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _firestoreColRef => _firestore.collection('tasks');

  bool _loading = false;
  bool get loading => _loading;

  TaskProvider() {
    getToDoTasks();
    getDoingTasks();
    getDoneTasks();
  }

  set loading(bool value) {
    _loading = value;

    notifyListeners();
  }

  Future<void> setTask(Task task) async {
    loading = true;

    await _firestoreColRef.doc().set(task.taskDataToMap());

    loading = false;
  }

  Future<void> updateStateTask(Task task) async {
    loading = true;

    await _firestoreColRef.doc(task.id).update({'state': task.state});

    loading = false;
  }

  Future<void> deleteTask(Task task) async {
    loading = true;

    await _firestoreColRef.doc(task.id).delete();

    loading = false;
  }

  Future<Task> getTask(String taskId) async {
    DocumentSnapshot documentSnapshot = await _firestoreColRef.doc(taskId).get();

    return Task.fromDocument(documentSnapshot);
  }

  Future<List<Task>> getToDoTasks() async {
    loading = true;

    final QuerySnapshot snapshot = await _firestoreColRef.where('state', isEqualTo: 'todo').get();

    for (var documentSnapshot in snapshot.docs.reversed) {
      toDoTasks.add(Task.fromDocument(documentSnapshot));
    }

    loading = false;

    return toDoTasks;
  }

  Future<List<Task>> getDoingTasks() async {
    loading = true;

    final QuerySnapshot snapshot = await _firestoreColRef.where('state', isEqualTo: 'doing').get();

    for (var documentSnapshot in snapshot.docs.reversed) {
      doingTasks.add(Task.fromDocument(documentSnapshot));
    }

    loading = false;

    return doingTasks;
  }

  Future<List<Task>> getDoneTasks() async {
    loading = true;

    final QuerySnapshot snapshot = await _firestoreColRef.where('state', isEqualTo: 'done').get();

    for (var documentSnapshot in snapshot.docs.reversed) {
      doneTasks.add(Task.fromDocument(documentSnapshot));
    }

    loading = false;

    return doneTasks;
  }

  Future<List<Task>> getAllTasks() async {
    final QuerySnapshot snapshot = await _firestoreColRef.get();

    for (var documentSnapshot in snapshot.docs.reversed) {
      allTasks.add(Task.fromDocument(documentSnapshot));
    }

    return allTasks;
  }
}