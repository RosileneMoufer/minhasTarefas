import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhas_tarefas/database/tasks_provider.dart';
import 'package:minhas_tarefas/models/task.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.green,
              onPressed: () {

              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
              },
            ),
          ]
        ),
      ),
    );
  }
}