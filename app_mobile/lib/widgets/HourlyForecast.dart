import 'package:flutter/material.dart';
import '../services/WeatherApi.dart';
import 'package:app_mobile/Unit.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/AppTheme.dart';

class DuBaoTheoGio extends StatelessWidget {
  final String city;

  const DuBaoTheoGio({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchForecast(city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 130,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.darkMode
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: 130,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.darkMode
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Center(
              child: Text(
                AppLanguage.getText("Lỗi dữ liệu", "Data error"),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          );
        }

        var forecastList = snapshot.data!;
        var hourly = forecastList.take(12).toList();

        return Container(
          height: 130,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.darkMode
                ? Colors.white.withOpacity(0.12)
                : Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              var item = hourly[index];

              String timeStr = item["dt_txt"].substring(11, 13);

              double temp = UnitSettings.convertTemperature(
                item["main"]["temp"],
              );

              var iconCode = item["weather"][0]["icon"];
              IconData iconData = getWeatherIcon(iconCode);

              return SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${timeStr}h",
                      style: TextStyle(
                        color: AppTheme.darkMode
                            ? Colors.white
                            : const Color(0xFF2DA4FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Icon(
                      iconData,
                      size: 26,
                      color: AppTheme.darkMode
                          ? Colors.white70
                          : const Color(0xFFD4AF37),
                    ),

                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFE600), Color(0xFFFF7A00)],
                      ).createShader(bounds),
                      child: Text(
                        "${temp.round()}${UnitSettings.temperatureSymbol()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black38,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

IconData getWeatherIcon(String iconCode) {
  if (iconCode.contains('d')) {
    return Icons.wb_sunny;
  } else if (iconCode.contains('n')) {
    return Icons.nights_stay;
  } else {
    return Icons.cloud;
  }
}
