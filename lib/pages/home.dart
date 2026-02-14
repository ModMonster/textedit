import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:text_edit/note.dart';
import 'package:text_edit/task.dart';
import 'package:text_edit/views/notes.dart';
import 'package:text_edit/views/tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void replaceNote(Note currentData, Note newData) {
    setState(() {
      noteList[noteList.indexOf(currentData)] = newData;
    });
    saveNoteList();
  }

  void deleteTask(TaskData taskData) {
    setState(() {
      taskList.remove(taskData);
    });
  }

  int navigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      NotesView(),
      TasksView()
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          // notes
          NavigationDestination(
            label: "Notes",
            icon: Icon(Icons.notes),
          ),
          // tasks
          NavigationDestination(
            label: "Tasks",
            icon: Icon(Icons.task_alt)
          ),
        ],
        selectedIndex: navigationIndex,
        onDestinationSelected: (index) {
          setState(() {
            navigationIndex = index;
          });
        },
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(animation: primaryAnimation, secondaryAnimation: secondaryAnimation, child: child),
        child: screens[navigationIndex],
      ),
    );
  }
}