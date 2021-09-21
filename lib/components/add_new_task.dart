import 'package:flutter/material.dart';
import 'package:minhas_tarefas/database/tasks_provider.dart';
import 'package:minhas_tarefas/models/task.dart';
import 'package:provider/provider.dart';

Future<void> showUpdateState(BuildContext context, Task task) {
  Size size = MediaQuery.of(context).size;

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Atualizar estado"),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                }
              ),
            ],
          ),
          content: Wrap(
            runSpacing: 12,
              children: [
                GestureDetector(
                  onTap: () {
                    task.state = 'todo';
                    Provider.of<TaskProvider>(context, listen: false).updateStateTask(task);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: size.width,
                    height: 40,
                    alignment: Alignment.center,
                    color: Colors.blue.withOpacity(0.3),
                    child: Text("Fazer")
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    task.state = 'doing';
                    Provider.of<TaskProvider>(context, listen: false).updateStateTask(task);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: size.width,
                      height: 40,
                      alignment: Alignment.center,
                      color: Colors.blue.withOpacity(0.3),
                      child: Text("Fazendo")
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    task.state = 'done';
                    Provider.of<TaskProvider>(context, listen: false).updateStateTask(task);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: size.width,
                      height: 40,
                      alignment: Alignment.center,
                      color: Colors.blue.withOpacity(0.3),
                      child: Text("Feito")
                  ),
                ),
              ],
            ),
        );
      });
}