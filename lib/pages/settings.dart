import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:text_edit/main.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String getCurrentThemeName() {
    switch (Hive.box("settings").get("theme")) {
      case 1:
        return "Light";
      case 2:
        return "Dark";
      default:
        return "System default";
    }
  }


  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box("settings");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text("Settings"),
          ),
          SliverSafeArea(
            top: false,
            bottom: true,
            sliver: SliverList.list(
              children: [
                // dark mode
                ListTile(
                  title: Text("Theme"),
                  subtitle: Text(getCurrentThemeName()),
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
                            int val = box.get("theme", defaultValue: 0);
                            
                            return RadioGroup(
                              groupValue: val,
                              onChanged: (value) {
                                if (value == null) return;
                                setState2(() {
                                  box.put("theme", value);
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
                  value: box.get("swipe_delete", defaultValue: true),
                  onChanged: (value) {
                    setState(() {
                      box.put("swipe_delete", value);
                    });
                  }
                ),
                Divider(),
                SettingsHeader("Require confirmation when:"),
                // ask when deleting
                SwitchListTile(
                  title: Text("Deleting notes and tasks"),
                  secondary: Icon(Icons.delete),
                  value: box.get("confirm.delete", defaultValue: true),
                  onChanged: (value) {
                    setState(() {
                      box.put("confirm.delete", value);
                    });
                  }
                ),
                // ask when discarding
                SwitchListTile(
                  title: Text("Discarding note changes"),
                  secondary: Icon(Icons.reply),
                  value: box.get("confirm.discard", defaultValue: true),
                  onChanged: (value) {
                    setState(() {
                      box.put("confirm.discard", value);
                    });
                  }
                ),
                // ask when clearing
                SwitchListTile(
                  title: Text("Clearing note contents"),
                  secondary: Icon(Icons.clear_all),
                  value: box.get("confirm.clear", defaultValue: true),
                  onChanged: (value) {
                    setState(() {
                      box.put("confirm.clear", value);
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
                              Navigator.pop(context);
                              Hive.box("notes").clear();
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
                              Navigator.pop(context);
                              Hive.box("tasks").clear();
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
          ),
        ],
      ),
    );
  }
}

class SettingsHeader extends StatelessWidget {
  final String title;
  const SettingsHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(57.0, 16.0, 8.0, 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}