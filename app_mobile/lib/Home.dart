import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ManHinhGPS());
  }
}

class ManHinhGPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("img/home.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(color: Colors.black.withOpacity(0.15)),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        NhietDoHienTai(),
                        SizedBox(height: 30),
                        buildSectionTitle("DỰ BÁO THEO GIỜ"),
                        DuBaoTheoGio(),
                        SizedBox(height: 20),
                        buildSectionTitle("DỰ BÁO 7 NGÀY"),
                        DuBaoTheoNgay(),
                        SizedBox(height: 20),
                        buildSectionTitle("CHI TIẾT"),
                        ThongTinChiTiet(),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Menu(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFFFFFF00), Color(0xFFFFA500)],
          ).createShader(bounds),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

// MENU
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//API SERVICES

const String apiKey = "21e22af1cab731edfd013dcefac288d5";
const String city = "Hanoi";

Future<dynamic> getData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Lỗi API");
  }
}

Future<Map<String, dynamic>> fetchCurrentWeather() async {
  return await getData(
    "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=vi",
  );
}

Future<List<dynamic>> fetchForecast() async {
  final data = await getData(
    "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=vi",
  );
  return data["list"];
}
// Nhiệt độ hiện tại

class NhietDoHienTai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCurrentWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.white);
        }
        if (snapshot.hasError) {
          return Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.white));
        }
        var data = snapshot.data!;
        var temp = data["main"]["temp"].round();
        var description = data["weather"][0]["description"];
        var max = data["main"]["temp_max"].round();
        var min = data["main"]["temp_min"].round();

        return Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFFFFFF00), Color(0xFFFFA500)],
              ).createShader(bounds),
              child: Text(
                "$temp°",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 110,
                  fontWeight: FontWeight.w200,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                ),
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "C:$max°  T:$min°",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                shadows: [Shadow(blurRadius: 4, color: Colors.black38)],
              ),
            ),
          ],
        );
      },
    );
  }
}

//DỰ BÁO THEO GIỜ

class DuBaoTheoGio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchForecast(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 130,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(
            height: 130,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text("Lỗi dữ liệu", style: TextStyle(color: Colors.white)),
            ),
          );
        }
        var forecastList = snapshot.data!;
        var hourly = forecastList.take(12).toList();

        return Container(
          height: 130,
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              var item = hourly[index];
              String timeStr = item["dt_txt"].substring(11, 13);
              var temp = item["main"]["temp"].round().toString();
              var iconCode = item["weather"][0]["icon"];
              IconData iconData = getWeatherIcon(iconCode);

              return Container(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${timeStr}h",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(iconData, color: Colors.white70, size: 26),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFFFFFF00), Color(0xFFFFA500)],
                      ).createShader(bounds),
                      child: Text(
                        "$temp°",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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

  IconData getWeatherIcon(String iconCode) {
    if (iconCode.contains('d')) {
      return Icons.wb_sunny;
    } else if (iconCode.contains('n')) {
      return Icons.nights_stay;
    } else {
      return Icons.cloud;
    }
  }
}

//DỰ BÁO  THEO NGÀY

class DuBaoTheoNgay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchForecast(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoading();
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
            double temp = item["main"]["temp"];

            if (temp < minTemp) minTemp = temp;
            if (temp > maxTemp) maxTemp = temp;

            rainTotal += item["pop"] ?? 0;
          }

          double rainAvg = rainTotal / dayData.length;

          String rainText = rainAvg > 0 ? "${(rainAvg * 100).round()}%" : "0%";

          dayWidgets.add(
            dayItem({
              "day": getDayName(date),
              "min": "${minTemp.round()}°",
              "max": "${maxTemp.round()}°",
              "rain": rainText,
            }),
          );

          count++;
        });

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(children: dayWidgets),
        );
      },
    );
  }

  Widget buildLoading() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  String getDayName(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Hôm nay";
    }

    List<String> weekdays = [
      "Th 2",
      "Th 3",
      "Th 4",
      "Th 5",
      "Th 6",
      "Th 7",
      "CN",
    ];

    return weekdays[dateTime.weekday - 1];
  }

  Widget dayItem(Map<String, String> item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                item["day"]!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
              Text(
                item["min"]!,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(width: 20),
              Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 20),
              Text(
                item["max"]!,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// THÔNG TIN CHI TIẾT
class ThongTinChiTiet extends StatelessWidget {
  const ThongTinChiTiet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
