import 'package:flutter/material.dart';
import 'package:app_mobile/SearchHistory.dart';
import 'package:app_mobile/AppTheme.dart';
import 'package:app_mobile/Language.dart';

import 'widgets/Menu.dart';
import 'widgets/CurrentWeather.dart';
import 'widgets/HourlyForecast.dart';
import 'widgets/DailyForecast.dart';
import 'widgets/WeatherDetails.dart';
import 'services/WeatherApi.dart';

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

  @override
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
                        const SizedBox(height: 20),

                        NhietDoHienTai(weatherFuture: weatherFuture),

                        const SizedBox(height: 30),

                        buildSectionTitle(
                          AppLanguage.getText(
                            "DỰ BÁO THEO GIỜ",
                            "HOURLY FORECAST",
                          ),
                        ),

                        DuBaoTheoGio(city: selectedCity),

                        const SizedBox(height: 20),

                        buildSectionTitle(
                          AppLanguage.getText(
                            "DỰ BÁO 7 NGÀY",
                            "7 DAY FORECAST",
                          ),
                        ),

                        DuBaoTheoNgay(city: selectedCity),

                        const SizedBox(height: 20),

                        buildSectionTitle(
                          AppLanguage.getText("CHI TIẾT", "DETAILS"),
                        ),

                        ThongTinChiTiet(),

                        const SizedBox(height: 40),
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
          shaderCallback: (bounds) => const LinearGradient(
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
