import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhas_tarefas/database/tasks_provider.dart';
import 'package:minhas_tarefas/models/task.dart';
import 'package:provider/provider.dart';

class AddNewTaskPage extends StatefulWidget {
  @override
  _AddNewTaskPageState createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title:
          const Text("Gerenciar tarefa"),
      ),
      body: body(),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          final _isValid = _form.currentState!.validate();

          if (_isValid) {
            _form.currentState!.save();
            if (_formData['id'] == null) {
              _formData['id'] = "null";
            }
            Provider.of<TaskProvider>(context, listen: false).setTask(
                Task(
                  id: _formData['id']!,
                  title: _formData['title']!,
                  description: _formData['description']!,
                  state: 'todo',
                )
            );

            Navigator.of(context).pop();
          }
        },
        child: Container(
          width: size.width,
          height: 56,
          color: Colors.blueGrey,
          alignment: Alignment.center,
          child: const Text(
            "Salvar",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (title) {
                        if ((title == null) || (title.trim().isEmpty)) {
                          return "erro";
                        }
                      },
                      onSaved: (title) => _formData['title'] = title!,
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: (description) {
                        if ((description == null) || (description.trim().isEmpty)) {
                          return "erro";
                        }
                        if (description.trim().length < 3) {
                          return "Nome muito pequeno.";
                        }
                      },
                      onSaved: (description) => _formData['description'] = description!,
                    ),
                  ],
                )
            )
        )
    );
  }
}