import 'package:flutter/material.dart';

class NoteSpacingSettings extends StatefulWidget {
  const NoteSpacingSettings({super.key});

  @override
  State<NoteSpacingSettings> createState() => _NoteSpacingSettingsState();
}

class _NoteSpacingSettingsState extends State<NoteSpacingSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text("Note density"),
          ),
          SliverList.list(
            children: [
              RadioListTile(
                value: 0,
                title: Text("Comfortable"),
              ),
              RadioListTile(
                value: 1,
                title: Text("Compact"),
              )
            ],
          )
        ]
      )
    );
  }
}