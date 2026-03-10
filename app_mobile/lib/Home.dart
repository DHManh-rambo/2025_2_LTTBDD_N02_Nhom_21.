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
import 'package:app_mobile/Unit.dart';
import 'package:app_mobile/AppTheme.dart';

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

  String getBackground() {
    if (AppTheme.darkMode == true) {
      return "img/home2.jpeg";
    } else {
      return "img/home.jpg";
    }
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
                image: AssetImage(getBackground()),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.25)],
              ),
            ),
          ),

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
              color: Theme.of(context).colorScheme.onBackground,
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
  String selectedCity = "Hanoi";

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
        color: Theme.of(context).cardColor.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
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
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
              size: 32,
            ),
            color: Theme.of(context).cardColor,
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'search',
                  child: Text(
                    AppLanguage.getText("Tìm kiếm", "Search"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'map',
                  child: Text(
                    AppLanguage.getText("Bản đồ", "Map"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'chart',
                  child: Text(
                    AppLanguage.getText("Biểu đồ", "Chart"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    AppLanguage.getText("Cài đặt", "Settings"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
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
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 110,
                  fontWeight: FontWeight.w200,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Theme.of(context).shadowColor,
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
                  Shadow(blurRadius: 6, color: Theme.of(context).shadowColor),
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
                  Shadow(blurRadius: 4, color: Theme.of(context).shadowColor),
                ],
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
        if (snapshot.hasError) {
          return Container(
            height: 130,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
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
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              var item = hourly[index];
              String timeStr = item["dt_txt"].substring(11, 13);
              double temp = UnitSettings.convertTemperature(
                item["main"]["temp"],
              );
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
                        color: Theme.of(
                          context,
                        ).colorScheme.onBackground.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(iconData, color: Theme.of(context).iconTheme.color),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFFFFFF00), Color(0xFFFFA500)],
                      ).createShader(bounds),
                      child: Text(
                        "${temp.round()}${UnitSettings.temperatureSymbol()}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
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
            color: Theme.of(context).cardColor.withOpacity(0.15),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(children: dayWidgets),
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
                  colors: [Color(0xFFA0A0A0), Color(0xFFFFFFFF)],
                ).createShader(bounds),
                child: Text(
                  item["min"]!,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 20),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFFA500), Color(0xFFFF4500)],
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
  @override
  Widget build(BuildContext context) {
    double wind = UnitSettings.convertWindSpeed(12);
    final details = [
      {
        "title": AppLanguage.getText("Gió", "Wind"),
        "value": "${wind.round()} ${UnitSettings.windSpeedSymbol()}",
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
            return box(context, item["title"]!, item["value"]!, item["sub"]!);
          },
        ),
      ),
    );
  }

  Widget box(BuildContext context, String title, String value, String sub) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.18),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
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
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
