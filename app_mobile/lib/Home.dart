import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_mobile/Search.dart';
import 'package:app_mobile/Chart.dart';
import 'package:app_mobile/SearchHistory.dart';
import 'package:app_mobile/Map.dart';
import 'package:app_mobile/Setting.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ManHinhGPS());
  }
}

class ManHinhGPS extends StatefulWidget {
  const ManHinhGPS({super.key});

  @override
  State<ManHinhGPS> createState() => _ManHinhGPSState();
}

class _ManHinhGPSState extends State<ManHinhGPS> {
  String selectedCity = "Hanoi";
  late Future<Map<String, dynamic>> weatherFuture;
  late Future<List<dynamic>> forecastFuture;
  List<String> _searchHistory = [];
  void refreshLanguage() {
    setState(() {
      weatherFuture = fetchCurrentWeather(selectedCity);
      forecastFuture = fetchForecast(selectedCity);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    weatherFuture = fetchCurrentWeather(selectedCity);
    forecastFuture = fetchForecast(selectedCity);
  }

  Future<void> _loadSearchHistory() async {
    List<String> history = await SearchHistoryService.getHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  void _refreshSearchHistory() {
    _loadSearchHistory();
  }

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
                        NhietDoHienTai(weatherFuture: weatherFuture),
                        SizedBox(height: 30),
                        buildSectionTitle(
                          AppLanguage.getText(
                            "DỰ BÁO THEO GIỜ",
                            "HOURLY FORECAST",
                          ),
                        ),
                        DuBaoTheoGio(city: selectedCity),
                        SizedBox(height: 20),
                        buildSectionTitle(
                          AppLanguage.getText(
                            "DỰ BÁO 7 NGÀY",
                            "7 DAY FORECAST",
                          ),
                        ),
                        DuBaoTheoNgay(city: selectedCity),
                        SizedBox(height: 20),
                        buildSectionTitle(
                          AppLanguage.getText("CHI TIẾT", "DETAILS"),
                        ),
                        ThongTinChiTiet(),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Menu(
                  searchHistory: _searchHistory,

                  onCityChanged: (city) {
                    setState(() {
                      selectedCity = city;
                      weatherFuture = fetchCurrentWeather(city);
                      forecastFuture = fetchForecast(city);
                    });
                  },
                  onSearchCompleted: _refreshSearchHistory,

                  onLanguageChanged: refreshLanguage,
                ),
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
class Menu extends StatefulWidget {
  final List<String> searchHistory;
  final Function(String)? onCityChanged;
  final VoidCallback? onSearchCompleted;
  final VoidCallback? onLanguageChanged;

  const Menu({
    super.key,
    required this.searchHistory,
    this.onCityChanged,
    this.onSearchCompleted,
    this.onLanguageChanged,
  });
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String selectedCity = "Hà Nội";

  @override
  void didUpdateWidget(covariant Menu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchHistory.isNotEmpty &&
        !widget.searchHistory.contains(selectedCity)) {
      setState(() {
        selectedCity = widget.searchHistory.first;
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedCity = value;
              });
              widget.onCityChanged?.call(value);
            },
            itemBuilder: (context) {
              if (widget.searchHistory.isEmpty) {
                return [PopupMenuItem(value: "Hà Nội", child: Text("Hà Nội"))];
              }

              return widget.searchHistory.map((city) {
                return PopupMenuItem(value: city, child: Text(city));
              }).toList();
            },
            child: Row(
              children: [
                Text(
                  selectedCity,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black38)],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.white, size: 32),
            color: Colors.black87,
            onSelected: (value) async {
              if (value == 'home') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherStart()),
                  (route) => false,
                );
              }
              if (value == 'settings') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );

                if (mounted) {
                  widget.onLanguageChanged?.call();
                }
              }
              if (value == 'search') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Search()),
                );
                if (mounted) {
                  setState(() {});
                  widget.onSearchCompleted?.call();
                }
              }
              if (value == 'map') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MAP()),
                );
              }
              if (value == 'chart') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chart()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'home',
                  child: Text(
                    AppLanguage.getText("Trang chủ", "Home"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'search',
                  child: Text(
                    AppLanguage.getText("Tìm kiếm", "Search"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'map',
                  child: Text(
                    AppLanguage.getText("Bản đồ", "Map"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'chart',
                  child: Text(
                    AppLanguage.getText("Biểu đồ", "Chart"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    AppLanguage.getText("Cài đặt", "Settings"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

//API SERVICES

const String apiKey = "21e22af1cab731edfd013dcefac288d5";

Future<dynamic> getData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Lỗi API");
  }
}

Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
  return await getData(
    "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=${AppLanguage.current.toLowerCase()}",
  );
}

Future<List<dynamic>> fetchForecast(String city) async {
  final data = await getData(
    "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=${AppLanguage.current.toLowerCase()}",
  );
  return data["list"];
}
// Nhiệt độ hiện tại

class NhietDoHienTai extends StatelessWidget {
  final Future<Map<String, dynamic>> weatherFuture;

  const NhietDoHienTai({required this.weatherFuture});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.white);
        }
        if (snapshot.hasError) {
          return Text(
            AppLanguage.getText("Lỗi tải dữ liệu", "Error loading data"),
            style: TextStyle(color: Colors.white),
          );
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
  final String city;
  const DuBaoTheoGio({required this.city});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchForecast(city),
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
              child: Text(
                AppLanguage.getText("Lỗi dữ liệu", "Data error"),
                style: TextStyle(color: Colors.white),
              ),
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
  final String city;

  const DuBaoTheoNgay({required this.city});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchForecast(city),
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
  @override
  Widget build(BuildContext context) {
    final details = [
      {
        "title": AppLanguage.getText("Gió", "Wind"),
        "value": "12 km/h",
        "sub": AppLanguage.getText("Hướng ĐN", "SE Direction"),
      },
      {
        "title": AppLanguage.getText("Độ ẩm", "Humidity"),
        "value": "90%",
        "sub": AppLanguage.getText("Điểm sương 19°", "Dew point 19°"),
      },
      {
        "title": AppLanguage.getText("Tầm nhìn", "Visibility"),
        "value": "15 km",
        "sub": AppLanguage.getText("Trong lành", "Clear"),
      },
      {
        "title": AppLanguage.getText("Mặt trời", "Sun"),
        "value": "06:22",
        "sub": AppLanguage.getText("Lặn 17:57", "Sunset 17:57"),
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: details.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = details[index];
            return box(item["title"]!, item["value"]!, item["sub"]!);
          },
        ),
      ),
    );
  }

  Widget box(String title, String value, String sub) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30, width: 1.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
