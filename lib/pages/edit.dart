import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:text_edit/note.dart';

class EditPage extends StatelessWidget {

  final Note noteData;
  EditPage(this.noteData);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: noteData.name);
    TextEditingController contentController = TextEditingController(text: noteData.contents);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        // saveNote(noteData, Note(titleController.text, contentController.text));
      },
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(6),
            )
          ),
          title: TextField(
            maxLength: 30,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
              ),
              counterText: "",
              hintText: "Tap to edit title"
            ),
            style: Theme.of(context).textTheme.titleLarge,
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
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context, "cancel");
                          },
                        ),
                        // yes
                        TextButton(
                          child: Text("Discard"),
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
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context, "cancel");
                          },
                        ),
                        // yes
                        TextButton(
                          child: Text("Clear"),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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