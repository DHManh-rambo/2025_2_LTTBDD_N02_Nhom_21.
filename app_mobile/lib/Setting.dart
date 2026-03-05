import 'package:flutter/material.dart';
import 'language.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String language = AppLanguage.current;
  @override
  Widget build(BuildContext context) {
    String title;
    String languageText;

    if (language == "VI") {
      title = "Cài đặt";
      languageText = "Ngôn ngữ";
    } else {
      title = "Settings";
      languageText = "Language";
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: ListView(
        children: [
          ListTile(
            title: Text(languageText),

            trailing: DropdownButton(
              value: language,
              items: const [
                DropdownMenuItem(value: "VI", child: Text("Tiếng Việt")),

                DropdownMenuItem(value: "EN", child: Text("English")),
              ],

              onChanged: (value) {
                setState(() {
                  language = value!;
                  AppLanguage.current = language;
                });
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
