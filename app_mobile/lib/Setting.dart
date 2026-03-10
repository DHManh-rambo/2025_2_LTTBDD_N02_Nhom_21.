import 'package:flutter/material.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String language = AppLanguage.current;
  String tempUnit = "C";
  String windUnit = "MS";
  @override
  void initState() {
    super.initState();
    tempUnit = UnitSettings.temperature;
    windUnit = UnitSettings.windSpeed;
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String languageText;
    String tempText;
    String windText;

    if (language == "VI") {
      title = "Cài đặt";
      languageText = "Ngôn ngữ";
      tempText = "Đơn vị nhiệt độ";
      windText = "Đơn vị tốc độ gió";
    } else {
      title = "Settings";
      languageText = "Language";
      tempText = "Temperature Unit";
      windText = "Wind Speed Unit";
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
              },
            ),
          ),
          ListTile(
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
          ListTile(
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
        ],
      ),
    );
  }
}
