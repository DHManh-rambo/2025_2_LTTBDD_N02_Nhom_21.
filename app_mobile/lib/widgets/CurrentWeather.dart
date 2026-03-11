import 'package:flutter/material.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';
import 'package:app_mobile/AppTheme.dart';

class NhietDoHienTai extends StatelessWidget {
  final Future<Map<String, dynamic>> weatherFuture;

  const NhietDoHienTai({required this.weatherFuture});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
        if (snapshot.hasError) {
          return Text(
            AppLanguage.getText("Lỗi tải dữ liệu", "Error loading data"),
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          );
        }
        var data = snapshot.data!;
        double temp = UnitSettings.convertTemperature(data["main"]["temp"]);
        var description = data["weather"][0]["description"];
        double max = UnitSettings.convertTemperature(data["main"]["temp_max"]);
        double min = UnitSettings.convertTemperature(data["main"]["temp_min"]);

        return Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFFFFFF00), Color(0xFFFFA500)],
              ).createShader(bounds),
              child: Text(
                "${temp.round()}${UnitSettings.temperatureSymbol()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 110,
                  fontWeight: FontWeight.w200,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: AppTheme.darkMode
                          ? Colors.black54
                          : Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: AppTheme.darkMode ? Colors.black54 : Colors.white70,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "C:${max.round()}${UnitSettings.temperatureSymbol()}  T:${min.round()}${UnitSettings.temperatureSymbol()}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 18,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: AppTheme.darkMode ? Colors.black54 : Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
