import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:text_edit/pages/edit.dart';

class NoteTile extends StatelessWidget {
  final Note noteData;
  final bool deleteMode;

  NoteTile(this.noteData, {this.deleteMode = false});

  @override
  Widget build(BuildContext context) {
    // add dismissible?
    if (swipeDelete) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          // show confirmation dialog
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Delete this note?"),
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
                  child: Text("Delete"),
                  onPressed: () {
                    Navigator.pop(context, "delete");
                    noteList.remove(noteData);
                  },
                ),
              ],
            ); 
          });
        },
        background: Container(
          alignment: AlignmentDirectional.centerStart,
          color: Theme.of(context).colorScheme.error,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(Icons.delete),
          ),
        ),
        secondaryBackground: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Theme.of(context).colorScheme.error,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(Icons.delete),
          ),
        ),
        child: noteCard(context),
      );
    } else {
      return noteCard(context);
    }    
  }

  Widget noteCard(BuildContext context) {
    return InkWell (
      onTap: (){
        if (deleteMode) {
          // show confirmation dialog
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Delete this note?"),
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
                  child: Text("Delete"),
                  onPressed: () {
                    Navigator.pop(context, "delete");
                    noteList.remove(noteData);
                  },
                ),
              ],
            ); 
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {return EditPage(noteData);}
            )
          );
        }
      },
      splashColor: deleteMode? Theme.of(context).colorScheme.errorContainer : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: Text(
                  noteData.name,
                  style: TextStyle(
                    fontSize: 30
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!compactView) ...[
                // preview
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text(
                    noteData.contents.isEmpty? "Tap to edit note." : noteData.contents,
                    style: TextStyle(
                      fontSize: 18
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ]
            ]
          ),
          // arrow
          Icon(deleteMode? Icons.delete : Icons.chevron_right)
        ]
      ),
      )
    );
  }
}

class Note {
  String name;
  String contents;

  Note(this.name, this.contents);
}