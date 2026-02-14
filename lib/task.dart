import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class TaskTile extends StatefulWidget {
  final int boxKey;
  final Task task;
  TaskTile(this.boxKey, this.task, {super.key});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final TextEditingController nameController = TextEditingController();
  final Box box = Hive.box("tasks");

  void showDeleteDialog(BuildContext context) {
    if (!Hive.box("settings").get("confirm.delete", defaultValue: false)) {
      box.delete(widget.boxKey);
      return;
    }

    // show confirmation dialog
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Delete this task?"),
        actions: [
          // no
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context, "cancel");
              setState(() {}); // rebuild because we didn't actually delete
            },
          ),
          // yes
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              Navigator.pop(context, "delete");
              box.delete(widget.boxKey);
            },
          ),
        ],
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        showDeleteDialog(context);
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
        value: widget.task.done,
        onChanged: (value) {
          widget.task.done = value ?? false;
          box.put(widget.boxKey, widget.task);
        },
        title: Text(
          widget.task.name.isEmpty? "Unnamed task" : widget.task.name,
          style: TextStyle(
            decoration: widget.task.done? TextDecoration.lineThrough : null,
            color: widget.task.done? Theme.of(context).colorScheme.onSurface.withAlpha(100) : null,
          ),
        ),
        // edit button
        secondary: IconButton(
          onPressed: () {
            nameController.text = widget.task.name;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Edit task"),
                  content: SizedBox(
                    width: 100,
                    child: TextField(
                      maxLength: 40,
                      decoration: InputDecoration(
                        hintText: "Task name",
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
                        box.delete(widget.boxKey);
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
                        widget.task.name = nameController.text;
                        box.put(widget.boxKey, widget.task);
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

class Task {
  String name;
  bool done;

  Task(this.name, {this.done = false});
}