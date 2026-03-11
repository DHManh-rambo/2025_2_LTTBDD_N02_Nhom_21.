import 'package:flutter/material.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';
import 'package:app_mobile/GroupInfo.dart';
import 'package:app_mobile/AppTheme.dart';
import 'package:app_mobile/main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String language = AppLanguage.current;
  String tempUnit = UnitSettings.temperature;
  String windUnit = UnitSettings.windSpeed;
  bool darkMode = AppTheme.darkMode;

  @override
  Widget build(BuildContext context) {
    String title;
    String languageText;
    String tempText;
    String windText;
    String darkModeText;
    String groupText;

    /// IF ELSE cho ngôn ngữ
    if (language == "VI") {
      title = "Cài đặt";
      languageText = "Ngôn ngữ";
      tempText = "Đơn vị nhiệt độ";
      windText = "Đơn vị tốc độ gió";
      darkModeText = "Chế độ tối";
      groupText = "Thông tin nhóm";
    } else {
      title = "Settings";
      languageText = "Language";
      tempText = "Temperature Unit";
      windText = "Wind Speed Unit";
      darkModeText = "Dark Mode";
      groupText = "Group Information";
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// LANGUAGE
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.language),
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
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// TEMPERATURE
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.thermostat),
                title: Text(tempText),
                trailing: DropdownButton(
                  value: tempUnit,
                  items: const [
                    DropdownMenuItem(value: "C", child: Text("°C")),
                    DropdownMenuItem(value: "F", child: Text("°F")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tempUnit = value!;
                      UnitSettings.temperature = tempUnit;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// WIND SPEED
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.air),
                title: Text(windText),
                trailing: DropdownButton(
                  value: windUnit,
                  items: const [
                    DropdownMenuItem(value: "MS", child: Text("m/s")),
                    DropdownMenuItem(value: "KMH", child: Text("km/h")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      windUnit = value!;
                      UnitSettings.windSpeed = windUnit;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// DARK MODE
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(darkModeText),
                trailing: Switch(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                      AppTheme.darkMode = value;
                    });

                    MyApp.of(context)?.refreshTheme();
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// GROUP INFO
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.group),
                title: Text(groupText),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GroupInfo()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
