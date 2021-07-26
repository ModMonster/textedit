import 'package:flutter/material.dart';
import 'package:text_edit/pages/about.dart';
import 'package:text_edit/pages/edit.dart';
import 'package:text_edit/pages/settings.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_edit/task.dart';
import 'note.dart';

// MY SAVIOR
bool deleteMode = false;

// settings
bool darkMode = false;
bool compactView = false;
bool swipeDelete = true;
bool askDelete = true;
bool askDiscard = true;
bool askClear = true;

List<NoteData> noteList = [];

List<TaskData> taskList = [];

// initialize preferences
SharedPreferences? prefs;
Future<void> initPreferences() async {
  // get shared preferences instance
  final prefs = await SharedPreferences.getInstance();

  // load settings
  darkMode = prefs.getBool("darkMode") ?? false;
  compactView = prefs.getBool("compactView") ?? false;
  swipeDelete = prefs.getBool("swipeDelete") ?? false;

  askDelete = prefs.getBool("askDelete") ?? true;
  askDiscard = prefs.getBool("askDiscard") ?? true;
  askClear = prefs.getBool("askClear") ?? true;
}

Future<void> saveNoteList() async {
  // set title list
  List<String> noteTitles = [];
  for (NoteData noteData in noteList) {
    noteTitles.add(noteData.name);
  }

  // set content list
  List<String> noteContents = [];
  for (NoteData noteData in noteList) {
    noteContents.add(noteData.contents);
  }

  // set prefs
  final prefs = await SharedPreferences.getInstance();

  prefs.setStringList("noteTitles", noteTitles);
  prefs.setStringList("noteContents", noteContents);
}

Future<void> saveTaskList() async {
  // set name list
  List<String> taskTitles = [];
  for (TaskData taskData in taskList) {
    taskTitles.add(taskData.name);
  }

  // set completed list
  List<String> taskContents = [];
  for (TaskData taskData in taskList) {
    if (taskData.done) {
      taskContents.add("true");
    } else {
      taskContents.add("false");
    }
  }

  // set prefs
  final prefs = await SharedPreferences.getInstance();

  prefs.setStringList("taskTitles", taskTitles);
  prefs.setStringList("taskContents", taskContents);
}

Future<void> restoreLists() async {
  final prefs = await SharedPreferences.getInstance();

  // set note list
  List<String> noteTitles = prefs.getStringList("noteTitles") ?? [];
  List<String> noteContents = prefs.getStringList("noteContents") ?? [];

  for (String noteTitle in noteTitles) {
    noteList.add(NoteData(noteTitle, noteContents[noteTitles.indexOf(noteTitle)]));
  }

  // set task list
  List<String> taskTitles = prefs.getStringList("taskTitles") ?? [];
  List<String> taskContents = prefs.getStringList("taskContents") ?? [];

  for (String taskTitle in taskTitles) {
    taskList.add(TaskData(taskTitle, taskContents[taskTitles.indexOf(taskTitle)] == "true"));
  }
}

void main() {
  restoreLists().whenComplete(() {
    return runApp(Phoenix(child: App()));
  });
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Widget _currentState = CircularProgressIndicator();

  void initState() {
    _reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _currentState;
  }

  void _reload() {
    initPreferences().whenComplete(() {
      setState((){_currentState = FinalApp();});
    });
  }
}

class FinalApp extends StatelessWidget {
  const FinalApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TextEdit",
      initialRoute: "/",
      routes: {
        "/": (context) {return HomePage();},
        "/settings": (context) {return SettingsPage();},
        "/settings/about": (context) {return AboutPage();},
      },
      themeMode: darkMode? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
    );
}
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void replaceNote(NoteData currentData, NoteData newData) {
    setState(() {
      noteList[noteList.indexOf(currentData)] = newData;
    });
    saveNoteList();
  }

  void tapNote(Note note, NoteData noteData, bool delete) {
    setState(() {
      if (delete) {
        // show confirmation dialog?
        if (askDelete) {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Delete this note?"),
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
                    "DELETE",
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "delete");
                    setState(() {
                      noteList.remove(noteData);
                      saveNoteList();
                    });
                  },
                ),
              ],
            ); 
          });
        } else {
          // remove note
          noteList.remove(noteData);
          saveNoteList();
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {return EditPage(noteData, replaceNote);}
          )
        );
      }
    });
  }

  void deleteTask(TaskData taskData) {
    setState(() {
      taskList.remove(taskData);
    });
  }

  int navigationIndex = 0;
  TextEditingController _newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(6),
          )
        ),
        backgroundColor: deleteMode ? Colors.red[400] : Colors.blueGrey,
        title: Text("TextEdit"),
        actions: [
          // add
          IconButton(
            icon: Icon(Icons.add),
            tooltip: navigationIndex == 0? "New Note": "New Task",
            onPressed: () {
              if (navigationIndex == 0) {
                setState(() {
                  noteList.insert(0, NoteData("New Note", ""));
                });
                saveNoteList();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("New Task"),
                      content: SizedBox(
                        width: 100,
                        child: TextField(
                          maxLength: 40,
                          decoration: InputDecoration(
                            hintText: "Task Name",
                          ),
                          controller: _newTaskController,
                        ),
                      ),
                      actions: [
                        // ok
                        TextButton(
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              taskList.insert(0, TaskData(_newTaskController.text, false));
                            });
                            saveTaskList();
                            _newTaskController.text = "";
                          },
                        ),
                      ],
                    );
                  }
                );
              }
            },
          ),
          // delete
          if (navigationIndex == 0) IconButton(
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
          ),
          SizedBox(width: 10)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          // notes
          BottomNavigationBarItem(
            label: "Notes",
            icon: Icon(Icons.notes)
          ),
          // tasks
          BottomNavigationBarItem(
            label: "Tasks",
            icon: Icon(Icons.task_alt)
          ),
        ],
        currentIndex: navigationIndex,
        onTap: (index) {
          setState(() {
            navigationIndex = index;
            _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
          });
        },
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.blue,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => navigationIndex = index);
          },
          children: <Widget>[
            notesPage(),
            tasksPage(),
          ],
        ),
      ),
    );
  }

  Widget notesPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView(
        children: noteList.map((note){return Note(note, tapNote);}).toList()
      ),
    );
  }

  Widget tasksPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView(
        children: taskList.map((task) {return Task(task, deleteTask);}).toList()
      ),
    );
  }
}