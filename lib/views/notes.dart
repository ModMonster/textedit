import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:text_edit/note.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
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
            tooltip: "New Note",
            onPressed: () {
              setState(() {
                noteList.insert(0, Note("New Note", ""));
              });
              saveNoteList();
            }
          ),
          IconButton(
            icon: Icon(deleteMode ? Icons.cancel : Icons.delete),
            tooltip: "Delete Notes",
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
      body: ListView(
        children: noteList.map((note) => NoteTile(note)).toList()
      ),
    );
  }
}