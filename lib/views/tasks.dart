import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:text_edit/task.dart';

class TasksView extends StatelessWidget {
  final TextEditingController _newTaskController = TextEditingController();

  TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box("tasks");

    return Scaffold(
      appBar: AppBar(
        title: Text("TextEdit"),
        actions: [
          // add
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "New task",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("New task"),
                    content: SizedBox(
                      width: 100,
                      child: TextField(
                        autofocus: true,
                        maxLength: 40,
                        decoration: InputDecoration(
                          hintText: "Task name",
                        ),
                        controller: _newTaskController,
                      ),
                    ),
                    actions: [
                      // cancel
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // ok
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          box.add(Task(_newTaskController.text));
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
      body: StreamBuilder(
        stream: box.watch(),
        builder: (context, asyncSnapshot) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) => TaskTile(box.keyAt(index), box.getAt(index)),
          );
        }
      )
    );
  }
}