import 'package:flutter/material.dart';
import '../services/WeatherApi.dart';
import 'package:app_mobile/Unit.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/AppTheme.dart';

class DuBaoTheoNgay extends StatelessWidget {
  final String city;

  const DuBaoTheoNgay({required this.city});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchForecast(city),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoading(context);
        }

        List<dynamic> forecastList = snapshot.data!;
        Map<String, List<dynamic>> grouped = {};

        for (var item in forecastList) {
          String date = item["dt_txt"].substring(0, 10);

          if (grouped.containsKey(date)) {
            grouped[date]!.add(item);
          } else {
            grouped[date] = [item];
          }
        }

        List<Widget> dayWidgets = [];

        int count = 0;

        grouped.forEach((date, dayData) {
          if (count >= 7) return;
          double minTemp = 100;
          double maxTemp = -100;
          double rainTotal = 0;

          for (var item in dayData) {
            double temp = UnitSettings.convertTemperature(item["main"]["temp"]);

            if (temp < minTemp) minTemp = temp;
            if (temp > maxTemp) maxTemp = temp;

            rainTotal += item["pop"] ?? 0;
          }

          double rainAvg = rainTotal / dayData.length;

          String rainText = rainAvg > 0 ? "${(rainAvg * 100).round()}%" : "0%";

          dayWidgets.add(
            dayItem(context, {
              "day": getDayName(date),
              "min": "${minTemp.round()}${UnitSettings.temperatureSymbol()}",
              "max": "${maxTemp.round()}${UnitSettings.temperatureSymbol()}",
              "rain": rainText,
            }),
          );

          count++;
        });

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
                ),
          child: Column(
                children: List.generate(dayWidgets.length, (index) {
                  return Column(
                    children: [
                      dayWidgets[index],
                      if (index != dayWidgets.length - 1)
                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          height: 1,
                        ),
                    ],
                  );
                }),
              ),
        );
      },
    );
  }

  Widget buildLoading(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  String getDayName(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return AppLanguage.getText("Hôm nay", "Today");
    }

    List<String> weekdays;
    if (AppLanguage.current == "VI") {
      weekdays = ["Th 2", "Th 3", "Th 4", "Th 5", "Th 6", "Th 7", "CN"];
    } else {
      weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    }

    return weekdays[dateTime.weekday - 1];
  }

  Widget dayItem(BuildContext context, Map<String, String> item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                ).createShader(bounds),
                child: Text(
                  item["day"]!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (item["rain"] != "0%")
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "🌧 ${item["rain"]}",
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFF2DA4FF),
                        Color(0xFF00C6FF),
                      ],
                    ).createShader(bounds),
                child: Text(
                  item["min"]!,
                  style: TextStyle(
                    color: AppTheme.darkMode
                        ? Colors.lightBlue
                        : Colors.blue.shade800,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                    width: 90,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2DA4FF),
                          Color(0xFFFF8C00),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),

              ),
              ),
              SizedBox(width: 20),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFFB300), Color(0xFFFF3D00)],
                ).createShader(bounds),
                child: Text(
                  item["max"]!,
                  style: TextStyle(
                    color: AppTheme.darkMode
                        ? Colors.orange
                        : Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
