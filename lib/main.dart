import 'package:flutter/material.dart';
import 'package:text_edit/pages/home.dart';
import 'package:text_edit/pages/note_spacing.dart';
import 'package:text_edit/pages/settings.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_edit/task.dart';
import 'note.dart';

String version = "2.0.0";

// MY SAVIOR
bool deleteMode = false;

// settings
bool darkMode = false;
bool compactView = false;
bool swipeDelete = true;
bool askDelete = true;
bool askDiscard = true;
bool askClear = true;

List<Note> noteList = [];

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
  for (Note noteData in noteList) {
    noteTitles.add(noteData.name);
  }

  // set content list
  List<String> noteContents = [];
  for (Note noteData in noteList) {
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
  // reset lists
  noteList = [];
  taskList = [];

  final prefs = await SharedPreferences.getInstance();

  // set note list
  List<String> noteTitles = prefs.getStringList("noteTitles") ?? [];
  List<String> noteContents = prefs.getStringList("noteContents") ?? [];

  for (String noteTitle in noteTitles) {
    noteList.add(Note(noteTitle, noteContents[noteTitles.indexOf(noteTitle)]));
  }

  // set task list
  List<String> taskTitles = prefs.getStringList("taskTitles") ?? [];
  List<String> taskContents = prefs.getStringList("taskContents") ?? [];

  for (String taskTitle in taskTitles) {
    taskList.add(TaskData(taskTitle, taskContents[taskTitles.indexOf(taskTitle)] == "true"));
  }
}

void main() {
  return runApp(Phoenix(child: App()));
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
      restoreLists().whenComplete(() {
        setState((){_currentState = FinalApp();});
      });
    });
  }
}

class FinalApp extends StatelessWidget {
  const FinalApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TextEdit",
      routes: {
        "/": (context) {return HomePage();},
        "/settings": (context) {return SettingsPage();},
        "/settings/note_spacing": (context) {return NoteSpacingSettings();}
      },
      themeMode: darkMode? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}