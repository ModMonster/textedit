import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:text_edit/hive/hive_registrar.g.dart';
import 'package:text_edit/pages/home.dart';
import 'package:text_edit/pages/note_spacing.dart';
import 'package:text_edit/pages/settings.dart';

String version = "2.0.0";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox("notes");
  await Hive.openBox("tasks");
  await Hive.openBox("settings");

  runApp(TextEditApp());
}

class TextEditApp extends StatelessWidget {
  const TextEditApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box("settings");
    
    return StreamBuilder(
      stream: box.watch(),
      builder: (context, asyncSnapshot) {
        return MaterialApp(
          title: "TextEdit",
          routes: {
            "/": (context) {return HomePage();},
            "/settings": (context) {return SettingsPage();},
            "/settings/note_spacing": (context) {return NoteSpacingSettings();}
          },
          themeMode: ThemeMode.values[box.get("theme", defaultValue: 0)],
          theme: ThemeData(
            colorSchemeSeed: Colors.blueGrey,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blueGrey,
          ),
        );
      }
    );
  }
}