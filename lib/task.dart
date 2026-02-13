import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';

class Task extends StatefulWidget {
  final TaskData taskData;
  final Function deleteTask;

  Task(this.taskData, this.deleteTask);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        widget.deleteTask(widget.taskData);
        saveTaskList();
      },
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Theme.of(context).colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Icon(Icons.delete),
        ),
      ),
      secondaryBackground: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Theme.of(context).colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          child: Icon(Icons.delete),
        ),
      ),
      // list tile
      child: CheckboxListTile(
        value: widget.taskData.done,
        onChanged: (value) {
          setState(() {
            widget.taskData.done = value ?? false;
          });
          saveTaskList();
        },
        title: Text(
          widget.taskData.name.isEmpty? "Unnamed Task" : widget.taskData.name,
          style: TextStyle(
            decoration: widget.taskData.done? TextDecoration.lineThrough : null,
            color: widget.taskData.done? Theme.of(context).colorScheme.onSurface.withAlpha(100) : null,
          ),
        ),
        // edit button
        secondary: IconButton(
          onPressed: () {
            nameController.text = widget.taskData.name;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Edit Task"),
                  content: SizedBox(
                    width: 100,
                    child: TextField(
                      maxLength: 40,
                      decoration: InputDecoration(
                        hintText: "Task Name",
                      ),
                      controller: nameController,
                    ),
                  ),
                  actions: [
                    // delete
                    TextButton(
                      child: Text("Delete"),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.deleteTask(widget.taskData);
                        saveTaskList();
                      },
                    ),
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
                        setState(() {
                          widget.taskData.name = nameController.text;
                        });
                        saveTaskList();
                      },
                    ),
                  ],
                );
              }
            );
          },
          icon: Icon(Icons.edit)
        )
      ),
    );
  }
}

class TaskData {
  String name;
  bool done;

  TaskData(this.name, this.done);
}