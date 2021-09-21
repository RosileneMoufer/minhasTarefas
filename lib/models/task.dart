import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late String id;
  late String title;
  late String description;
  late String state;

  List<Task> tasks = [];

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
  });

  Task.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    title = documentSnapshot.get('title');
    description = documentSnapshot.get('description');
    state = documentSnapshot.get('state');
  }

  Map<String, dynamic> taskDataToMap() {
    return {
      'title': title,
      'description': description,
      'state': state,
    };
  }
}