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
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text("Settings"),
          ),
          SliverList.list(
            children: [
              // dark mode
              ListTile(
                title: Text("Theme"),
                subtitle: Text(darkMode? "Dark" : "Light"),
                leading: Icon(Icons.palette_outlined),
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Choose theme"),
                      contentPadding: EdgeInsets.only(top: 8.0),
                      content: StatefulBuilder(
                        builder: (context, setState2) {
                          // Putting this directly in doesn't work.
                          // Do not ask me why, I have literally no idea.
                          // int val = box.get("theme", defaultValue: 0);
                          
                          return RadioGroup(
                            groupValue: darkMode? 0 : 1,
                            onChanged: (value) {
                              if (value == null) return;
                              setState2(() {
                                // box.put("theme", value);
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                  value: 1,
                                  title: Text("Light"),
                                ),
                                RadioListTile(
                                  value: 2,
                                  title: Text("Dark"),
                                ),
                                RadioListTile(
                                  value: 0,
                                  title: Text("System default"),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK")
                        )
                      ],
                    );
                  });
                },
              ),
              // compact view
              ListTile(
                title: Text("Note density"),
                leading: Icon(Icons.view_compact_rounded),
                subtitle: Text("Comfortable"),
                onTap: () {
                  Navigator.pushNamed(context, "/settings/note_spacing");
                },
              ),
              // ask when deleting
              SwitchListTile(
                title: Text("Swipe to delete notes"),
                secondary: Icon(Icons.delete_sweep),
                value: swipeDelete,
                onChanged: (value) {setState(() {
                  _setBool("swipeDelete", value).whenComplete(() {
                    return setState(() {
                      swipeDelete = value;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Require confirmation when:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              // ask when deleting
              SwitchListTile(
                title: Text("Deleting notes and tasks"),
                secondary: Icon(Icons.delete),
                value: askDelete,
                onChanged: (value) {setState(() {
                  _setBool("askDelete", value).whenComplete(() {
                    return setState(() {
                      askDelete = value;
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
              SwitchListTile(
                title: Text("Discarding note changes"),
                secondary: Icon(Icons.reply),
                value: askDiscard,
                onChanged: (value) {setState(() {
                  _setBool("askDiscard", value).whenComplete(() {
                    return setState(() {
                      askDiscard = value;
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
              SwitchListTile(
                title: Text("Clearing note contents"),
                secondary: Icon(Icons.clear_all),
                value: askClear,
                onChanged: (value) {setState(() {
                  _setBool("askClear", value).whenComplete(() {
                    return setState(() {
                      askClear = value;
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
                title: Text("Delete all notes"),
                leading: Icon(Icons.delete_forever_outlined),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {return AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("All of your notes will be permanently deleted."),
                      actions: [
                        // no
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // yes
                        TextButton(
                          child: Text("OK"),
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
                title: Text("Delete all tasks"),
                leading: Icon(Icons.delete_forever_outlined),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {return AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("All of your tasks will be permanently deleted."),
                      actions: [
                        // no
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // yes
                        TextButton(
                          child: Text("OK"),
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
                title: Text("View on GitHub"),
                leading: Icon(Icons.code),
                onTap: () {launchUrl(Uri.parse("https://github.com/modmonster/textedit"));},
              ),
              ListTile(
                title: Text("Report a bug"),
                leading: Icon(Icons.bug_report_outlined),
                onTap: () {launchUrl(Uri.parse("https://github.com/modmonster/textedit/issues/new"));},
              ),
              // about
              AboutListTile(
                icon: Icon(Icons.info_outline),
                applicationName: "TextEdit",
                applicationIcon: Image.asset(
                  "assets/icon-circle.png",
                  width: 48,
                ),
                applicationVersion: version,
                aboutBoxChildren: [
                  Text("A simple text editor and to-do list")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}