import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:text_edit/note.dart';

class EditPage extends StatelessWidget {

  final NoteData noteData;
  final Function saveNote;
  EditPage(this.noteData, this.saveNote);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: noteData.name);
    TextEditingController contentController = TextEditingController(text: noteData.contents);

    return WillPopScope(
      onWillPop: () async {
        saveNote(noteData, NoteData(titleController.text, contentController.text));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(6),
            )
          ),
          backgroundColor: Colors.blueGrey,
          title: TextField(
            maxLength: 30,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              hintText: "Tap to edit title"
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
            controller: titleController,
          ),
          actions: [
            // discard changes
            IconButton(
              tooltip: "Discard Changes",
              onPressed: () {
                if (askDiscard) {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Discard changes?"),
                      content: Text("This will discard all of the changes you made since the last time you saved the note."),
                      actions: [
                        // no
                        TextButton(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              color: Colors.blue
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "cancel");
                          },
                        ),
                        // yes
                        TextButton(
                          child: Text(
                            "DISCARD",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "discard");
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ); 
                  });
                } else {
                  // discard
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.reply)
            ),
            // clear note
            IconButton(
              tooltip: "Clear Note",
              onPressed: () {
                if (askClear) {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Clear this note?"),
                      content: Text("This will delete all of the contents of this note, but not the note itself."),
                      actions: [
                        // no
                        TextButton(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              color: Colors.blue
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "cancel");
                          },
                        ),
                        // yes
                        TextButton(
                          child: Text(
                            "CLEAR",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "clear");
                            contentController.text = "";
                          },
                        ),
                      ],
                    ); 
                 });
                } else {
                  contentController.text = "";
                }
              },
              icon: Icon(Icons.clear_all)
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: double.infinity,
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Tap to edit note"
              ),
              controller: contentController,
            ),
          ),
        )
      ),
    );
  }
}