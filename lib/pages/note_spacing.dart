import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class NoteSpacingSettings extends StatefulWidget {
  const NoteSpacingSettings({super.key});

  @override
  State<NoteSpacingSettings> createState() => _NoteSpacingSettingsState();
}

class _NoteSpacingSettingsState extends State<NoteSpacingSettings> {
  final Box box = Hive.box("settings");
  
  @override
  Widget build(BuildContext context) {
    int val = box.get("density", defaultValue: 0);

    return Scaffold(
      body: RadioGroup(
        groupValue: val,
        onChanged: (value) {
          setState(() {
            box.put("density", value);
          });
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text("Note density"),
            ),
            SliverList.list(
              children: [
                RadioListTile(
                  value: 0,
                  title: Text("Default"),
                  secondary: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Image.asset(
                        "assets/density-default.png",
                        color: Theme.of(context).colorScheme.outline,
                        colorBlendMode: BlendMode.srcIn,
                      )
                    ),
                  ),
                ),
                RadioListTile(
                  value: 1,
                  title: Text("Compact"),
                  secondary: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Image.asset(
                        "assets/density-compact.png",
                        color: Theme.of(context).colorScheme.outline,
                        colorBlendMode: BlendMode.srcIn,
                      )
                    ),
                  ),
                )
              ],
            )
          ]
        ),
      )
    );
  }
}