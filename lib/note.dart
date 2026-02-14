import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:text_edit/pages/edit.dart';

class NoteTile extends StatefulWidget {
  final int boxKey;
  final Note note;
  final bool deleteMode;
  NoteTile(this.boxKey, this.note, {this.deleteMode = false});

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  final Box box = Hive.box("notes");

  void showDeleteDialog(BuildContext context) {
    if (!Hive.box("settings").get("confirm.delete", defaultValue: true)) {
      box.delete(widget.boxKey);
      return;
    }

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
    // add dismissible?
    if (Hive.box("settings").get("swipe_delete", defaultValue: true)) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          showDeleteDialog(context);
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
      onTap: () {
        if (widget.deleteMode) {
          showDeleteDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {return EditPage(widget.boxKey, widget.note);}
            )
          );
        }
      },
      splashColor: widget.deleteMode? Theme.of(context).colorScheme.errorContainer : null,
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
                  widget.note.name,
                  style: TextStyle(
                    fontSize: 30
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (Hive.box("settings").get("density") != 1) ...[
                // preview
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text(
                    widget.note.contents.isEmpty? "Tap to edit note." : widget.note.contents,
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
          Icon(widget.deleteMode? Icons.delete : Icons.chevron_right)
        ]
      ),
      )
    );
  }
}

class Note {
  String name;
  String contents;

  Note(this.name, {this.contents = ""});
}