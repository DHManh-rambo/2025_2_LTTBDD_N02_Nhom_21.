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

Future<Map<String, dynamic>> fetchCurrentWeather() async {
  final response = await http.get(
    Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=vi",
    ),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Lỗi tải dữ liệu thời tiết hiện tại");
  }
}

Future<List<dynamic>> fetchForecast() async {
  final response = await http.get(
    Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=vi",
    ),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)["list"];
  } else {
    throw Exception("Lỗi tải dữ liệu dự báo");
  }
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
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
        Map<String, List<dynamic>> grouped = {};
        for (var item in forecastList) {
          String date = item["dt_txt"].substring(0, 10);
          grouped.putIfAbsent(date, () => []).add(item);
        }

        var entries = grouped.entries.toList();
        var sevenDays = entries.take(7).map((e) {
          var dayData = e.value;
          var temps = dayData.map((d) => d["main"]["temp"].toDouble()).toList();
          var min = temps.reduce((a, b) => a < b ? a : b).round();
          var max = temps.reduce((a, b) => a > b ? a : b).round();
          var rainProb =
              dayData.map((d) => d["pop"] ?? 0).reduce((a, b) => a + b) /
              dayData.length;
          var rainPercent = (rainProb * 100).round().toString() + "%";

          DateTime dateTime = DateTime.parse(e.key);
          DateTime now = DateTime.now();
          String dayName;

          if (dateTime.year == now.year &&
              dateTime.month == now.month &&
              dateTime.day == now.day) {
            dayName = "Hôm nay";
          } else if (dateTime.year == now.year &&
              dateTime.month == now.month &&
              dateTime.day == now.day + 1) {
            dayName = "Ngày mai";
          } else {
            switch (dateTime.weekday) {
              case 1:
                dayName = "Th 2";
                break;
              case 2:
                dayName = "Th 3";
                break;
              case 3:
                dayName = "Th 4";
                break;
              case 4:
                dayName = "Th 5";
                break;
              case 5:
                dayName = "Th 6";
                break;
              case 6:
                dayName = "Th 7";
                break;
              case 7:
                dayName = "CN";
                break;
              default:
                dayName = "";
            }
          }

          return {
            "day": dayName,
            "min": "$min°",
            "max": "$max°",
            "rain": rainProb > 0 ? rainPercent : "0%",
          };
        }).toList();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Column(
            children: sevenDays.map((item) => dayItem(item)).toList(),
          ),
        );
      },
    );
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
                  shadows: [Shadow(blurRadius: 4, color: Colors.black38)],
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
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFFFF00), Color(0xFFFFA500)],
                ).createShader(bounds),
                child: Text(
                  item["max"]!,
                  style: TextStyle(
                    color: Colors.white,
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

// THÔNG TIN CHI TIẾT
class ThongTinChiTiet extends StatelessWidget {
  const ThongTinChiTiet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
