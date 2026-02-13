import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(6),
          )
        ),
        title: Text("About TextEdit"),
      ),
      body: ListView(
        children: [
          // version
          ListTile(
            title: Text("Version"),
            subtitle: Text("v2.0.0"),
          ),
          ListTile(
            title: Text("View on GitHub"),
            onTap: () {launchUrl(Uri.parse("https://github.com/modmonster/textedit"));},
          ),
          ListTile(
            title: Text("Made by ModMonster"),
            subtitle: InkWell(
              onTap: () {launchUrl(Uri.parse("https://youtube.com/modmonster"));},
              child: Text(
                "https://youtube.com/modmonster",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              )
            ),
          ),
        ]
      )
    );
  }
}