import 'package:flutter/material.dart';
import 'package:text_edit/main.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _setBool(String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(6),
          )
        ),
        backgroundColor: Colors.blueGrey,
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          // dark mode
          SwitchListTile(
            title: Text("Dark Mode"),
            secondary: Icon(Icons.dark_mode),
            value: darkMode,
            onChanged: (value) {
              _setBool("darkMode", value).whenComplete(() {
                return setState(() {
                  darkMode = value;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restart TextEdit to apply changes."),
                      action: SnackBarAction(
                        label: "RESTART",
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                      )
                    )
                  );
                }
              );
              });
            }
          ),
          // compact view
          SwitchListTile(
            title: Text("Compact View"),
            secondary: Icon(Icons.view_compact_rounded),
            value: compactView,
            onChanged: (value) {setState(() {
              _setBool("compactView", value).whenComplete(() {
                return setState(() {
                  compactView = value;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restart TextEdit to apply changes."),
                      action: SnackBarAction(
                        label: "RESTART",
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                      )
                    )
                  );
                }
              );
              });
            });}
          ),
          // ask when deleting
          CheckboxListTile(
            title: Text("Swipe to delete notes"),
            secondary: Icon(Icons.delete_sweep),
            value: swipeDelete,
            onChanged: (value) {setState(() {
              _setBool("swipeDelete", value ?? false).whenComplete(() {
                return setState(() {
                  swipeDelete = value ?? false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restart TextEdit to apply changes."),
                      action: SnackBarAction(
                        label: "RESTART",
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                      )
                    )
                  );
                }
              );
              });
            });
            }
          ),
          Divider(),
          // ask when deleting
          CheckboxListTile(
            title: Text("Ask for confirmation when deleting notes"),
            secondary: Icon(Icons.delete),
            value: askDelete,
            onChanged: (value) {setState(() {
              _setBool("askDelete", value ?? false).whenComplete(() {
                return setState(() {
                  askDelete = value ?? false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restart TextEdit to apply changes."),
                      action: SnackBarAction(
                        label: "RESTART",
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                      )
                    )
                  );
                }
              );
              });
            });
            }
          ),
          // ask when discarding
          CheckboxListTile(
            title: Text("Ask for confirmation when discarding changes"),
            secondary: Icon(Icons.reply),
            value: askDiscard,
            onChanged: (value) {setState(() {
              _setBool("askDiscard", value ?? false).whenComplete(() {
                return setState(() {
                  askDiscard = value ?? false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restart TextEdit to apply changes."),
                      action: SnackBarAction(
                        label: "RESTART",
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                      )
                    )
                  );
                }
              );
              });
            });
            }
          ),
          // ask when clearing
          CheckboxListTile(
            title: Text("Ask for confirmation when clearing notes"),
            secondary: Icon(Icons.clear_all),
            value: askClear,
            onChanged: (value) {setState(() {
              _setBool("askClear", value ?? false).whenComplete(() {
                return setState(() {
                  askClear = value ?? false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restart TextEdit to apply changes."),
                      action: SnackBarAction(
                        label: "RESTART",
                        onPressed: () {
                          Phoenix.rebirth(context);
                        },
                      )
                    )
                  );
                }
              );
              });
            });
            }
          ),
          Divider(),
          // delete all notes
          ListTile(
            title: Text("Delete All Notes"),
            leading: Icon(Icons.notes),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {return AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("All of your notes will be deleted forever."),
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
                        Navigator.pop(context);
                      },
                    ),
                    // yes
                    TextButton(
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                      onPressed: () {
                        noteList = [];
                        saveNoteList();
                        Phoenix.rebirth(context);
                      },
                    ),
                  ],
                );}
              );
            },
          ),
          // delete all tasks
          ListTile(
            title: Text("Delete All Tasks"),
            leading: Icon(Icons.task_alt),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {return AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("All of your tasks will be deleted forever."),
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
                        Navigator.pop(context);
                      },
                    ),
                    // yes
                    TextButton(
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                      onPressed: () {
                        taskList = [];
                        saveTaskList();
                        Phoenix.rebirth(context);
                      },
                    ),
                  ],
                );}
              );
            },
          ),
          Divider(),
          // report bug
          ListTile(
            title: Text("Report a Bug"),
            leading: Icon(Icons.bug_report),
            onTap: () {launch("https://github.com/modmonster/textedit/issues/new");},
          ),
          // about
          ListTile(
            title: Text("About TextEdit"),
            leading: Icon(Icons.info),
            onTap: () {Navigator.pushNamed(context, "/settings/about");},
          ),
        ],
      ),
    );
  }
}