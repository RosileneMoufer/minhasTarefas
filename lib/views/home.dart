import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minhas_tarefas/components/add_new_task.dart';
import 'package:minhas_tarefas/database/tasks_provider.dart';
import 'package:minhas_tarefas/models/task.dart';
import 'package:minhas_tarefas/views/add_new_task.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentPage;
  late bool _delete;
  late Task _task;
  late int _selectedItem;

  @override
  void initState() {
    super.initState();

    _delete = false;
    _currentPage = 0;
    _selectedItem = -1;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Lista de tarefas"),
        actions: <Widget>[
          _delete
              ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false).deleteTask(_task);

                    setState(() {
                      _delete = false;
                    });
                  },
                )
              : Container(),
        ],
      ),
      body: Column(children: [
        menu(),
        Container(
          width: size.width,
          height: size.height * 0.79,
          color: Colors.white,
          child: IndexedStack(
            index: _currentPage,
            children: [
              tasksToDoList(),
              tasksToDoingList(),
              tasksToDoneList(),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewTaskPage()));
        },
        child: Container(
          width: size.width,
          height: 56,
          color: Colors.blueGrey,
          alignment: Alignment.center,
          child: const Text(
            "Nova tarefa",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 0;
                _delete = false;
                _selectedItem = -1;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.0,
                    color: _currentPage == 0
                        ? Colors.blue
                        : Colors.grey.withOpacity(0),
                  ),
                ),
                color: Colors.white,
              ),
              child: Text(
                "Fazer",
                style: TextStyle(
                  color: _currentPage == 0 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 1;
                _delete = false;
                _selectedItem = -1;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.0,
                    color: _currentPage == 1
                        ? Colors.blue
                        : Colors.grey.withOpacity(0),
                  ),
                ),
                color: Colors.white,
              ),
              child: Text(
                "Fazendo",
                style: TextStyle(
                  color: _currentPage == 1 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 2;
                _delete = false;
                _selectedItem = -1;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.0,
                    color: _currentPage == 2
                        ? Colors.blue
                        : Colors.grey.withOpacity(0),
                  ),
                ),
                color: Colors.white,
              ),
              child: Text(
                "Feito",
                style: TextStyle(
                  color: _currentPage == 2 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tasksToDoList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('state', isEqualTo: 'todo')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView(
              children: List.generate(snapshot.data!.docs.length, (index) {
            return Padding(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 8, bottom: 8),
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _delete = !_delete;

                      _selectedItem = index;

                      if (_delete) {
                        _task = Task(
                            id: snapshot.data!
                                .docs
                                .elementAt(index)
                                .id,
                            title:
                            snapshot.data!.docs.elementAt(index).get('title'),
                            description: snapshot.data!.docs
                                .elementAt(index)
                                .get('description'),
                            state: snapshot.data!.docs
                                .elementAt(index)
                                .get('state'));
                      }
                    });
                  },
                  onTap: () {
                    Task task = Task(
                        id: snapshot.data!.docs.elementAt(index).id,
                        title:
                            snapshot.data!.docs.elementAt(index).get('title'),
                        description: snapshot.data!.docs
                            .elementAt(index)
                            .get('description'),
                        state:
                            snapshot.data!.docs.elementAt(index).get('state'));

                    showUpdateState(context, task);
                  },
                  child: Container(
                    color: (_delete && (_selectedItem == index)) ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.docs.elementAt(index).get('title'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(snapshot.data!.docs
                            .elementAt(index)
                            .get('description')),
                      ],
                    ),
                  ),
                ));
          }));
        }

        return Container();
      },
    );
  }

  Widget tasksToDoingList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('state', isEqualTo: 'doing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView(
              children: List.generate(snapshot.data!.docs.length, (index) {
            return Padding(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 8, bottom: 8),
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _delete = !_delete;

                      _selectedItem = index;

                      if (_delete) {
                        _task = Task(
                            id: snapshot.data!
                                .docs
                                .elementAt(index)
                                .id,
                            title:
                            snapshot.data!.docs.elementAt(index).get('title'),
                            description: snapshot.data!.docs
                                .elementAt(index)
                                .get('description'),
                            state: snapshot.data!.docs
                                .elementAt(index)
                                .get('state'));
                      }
                    });
                  },
                  onTap: () {
                    Task task = Task(
                        id: snapshot.data!.docs.elementAt(index).id,
                        title:
                            snapshot.data!.docs.elementAt(index).get('title'),
                        description: snapshot.data!.docs
                            .elementAt(index)
                            .get('description'),
                        state:
                            snapshot.data!.docs.elementAt(index).get('state'));

                    showUpdateState(context, task);
                  },
                  child: Container(
                    color: (_delete && (_selectedItem == index)) ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.docs.elementAt(index).get('title'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(snapshot.data!.docs
                            .elementAt(index)
                            .get('description')),
                      ],
                    ),
                  ),
                ));
          }));
        }

        return Container();
      },
    );
  }

  Widget tasksToDoneList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('state', isEqualTo: 'done')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView(
              children: List.generate(snapshot.data!.docs.length, (index) {
            return Padding(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 8, bottom: 8),
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _delete = !_delete;

                      _selectedItem = index;

                      if (_delete) {
                        _task = Task(
                            id: snapshot.data!
                                .docs
                                .elementAt(index)
                                .id,
                            title:
                            snapshot.data!.docs.elementAt(index).get('title'),
                            description: snapshot.data!.docs
                                .elementAt(index)
                                .get('description'),
                            state: snapshot.data!.docs
                                .elementAt(index)
                                .get('state'));
                      }
                    });
                  },
                  onTap: () {
                    Task task = Task(
                        id: snapshot.data!.docs.elementAt(index).id,
                        title:
                            snapshot.data!.docs.elementAt(index).get('title'),
                        description: snapshot.data!.docs
                            .elementAt(index)
                            .get('description'),
                        state:
                            snapshot.data!.docs.elementAt(index).get('state'));

                    showUpdateState(context, task);
                  },
                  child: Container(
                    color: (_delete && (_selectedItem == index)) ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.docs.elementAt(index).get('title'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(snapshot.data!.docs
                            .elementAt(index)
                            .get('description')),
                      ],
                    ),
                  ),
                ));
          }));
        }

        return Container();
      },
    );
  }
}
