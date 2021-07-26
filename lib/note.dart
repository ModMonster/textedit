import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';

class Note extends StatelessWidget {

  final NoteData noteData;
  final Function onTap;

  Note(this.noteData, this.onTap);

  @override
  Widget build(BuildContext context) {
    // add dismissible?
    if (swipeDelete) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          onTap(this, this.noteData, true);
        },
        background: Container(
          alignment: AlignmentDirectional.centerStart,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(Icons.delete),
          ),
        ),
        secondaryBackground: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
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
        onTap(this, this.noteData, deleteMode);
      },
      splashColor: deleteMode? Colors.red[200] : Colors.blueGrey[100],
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

class NoteData {
  String name;
  String contents;

  NoteData(this.name, this.contents);
}