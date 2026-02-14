import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:text_edit/note.dart';
import 'package:text_edit/pages/edit.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  bool deleteMode = false;

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box("notes");

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(6),
          )
        ),
        backgroundColor: deleteMode? Theme.of(context).colorScheme.errorContainer : null,
        title: Text("TextEdit"),
        actions: [
          // add
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "New note",
            onPressed: () async {
              Note note = Note("New note");
              int boxKey = await box.add(note);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {return EditPage(boxKey, note);}
                )
              );
            }
          ),
          IconButton(
            icon: Icon(deleteMode ? Icons.cancel : Icons.delete),
            tooltip: "Delete notes",
            onPressed: () {
              setState(() {
                deleteMode = !deleteMode;
              });
            },
          ),
          // settings
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: box.watch(),
        builder: (context, asyncSnapshot) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) => NoteTile(box.keyAt(index), box.getAt(index), deleteMode: deleteMode),
          );
        }
      )
    );
  }
}