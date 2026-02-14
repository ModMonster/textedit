import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:text_edit/task.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final TextEditingController _newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(6),
          )
        ),
        title: Text("TextEdit"),
        actions: [
          // add
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "New Task",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("New Task"),
                    content: SizedBox(
                      width: 100,
                      child: TextField(
                        autofocus: true,
                        maxLength: 40,
                        decoration: InputDecoration(
                          hintText: "Task Name",
                        ),
                        controller: _newTaskController,
                      ),
                    ),
                    actions: [
                      // ok
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            taskList.insert(0, TaskData(_newTaskController.text, false));
                          });
                          saveTaskList();
                          _newTaskController.text = "";
                        },
                      ),
                    ],
                  );
                }
              );
            }
          ),
          // settings
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
          SizedBox(width: 10)
        ],
      ),
      body: ListView(
        children: taskList.map((task) => Task(task)).toList()
      )
    );
  }
}