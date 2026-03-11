import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';

const String apiKey = "21e22af1cab731edfd013dcefac288d5";

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _cityController = TextEditingController();

  Map<String, dynamic>? _weatherData;

  bool _isLoading = false;
  String? _errorMessage;

  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _searchWeather() async {
    String city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _errorMessage = AppLanguage.getText(
          "Vui lòng nhập tên thành phố",
          "Please enter a city name",
        );
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weatherData = null;
    });

    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=${AppLanguage.current.toLowerCase()}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _weatherData = data;
          _isLoading = false;
        });

        await _saveToHistory(city);
        await _loadHistory();
      } else {
        setState(() {
          _errorMessage = AppLanguage.getText(
            "Không tìm thấy thành phố",
            "City not found",
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppLanguage.getText(
          "Lỗi kết nối, vui lòng thử lại",
          "Connection error, please try again",
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_history') ?? [];

    if (!history.contains(city)) {
      history.insert(0, city);
      if (history.length > 10) history.removeLast();
      await prefs.setStringList('search_history', history);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.getText("Tìm kiếm", "Search")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: AppLanguage.getText(
                  "Nhập tên thành phố...",
                  "Enter city name...",
                ),
                prefixIcon: Icon(Icons.location_city),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWeather,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => _searchWeather(),
            ),

            const SizedBox(height: 20),

            if (searchHistory.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLanguage.getText("Lịch sử tìm kiếm", "Search history"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.history),
                        title: Text(searchHistory[index]),
                        onTap: () {
                          _cityController.text = searchHistory[index];
                          _searchWeather();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],

            if (_isLoading) const CircularProgressIndicator(),

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),

            if (_weatherData != null) ...[
              const SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        _weatherData!["name"],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Icon(Icons.wb_sunny, size: 70, color: Colors.orange),

                      const SizedBox(height: 10),

                      Text(
                        "${UnitSettings.convertTemperature(_weatherData!["main"]["temp"]).round()}${UnitSettings.temperatureSymbol()}",
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w200,
                        ),
                      ),

                      Text(
                        _weatherData!["weather"][0]["description"],
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoColumn(
                            AppLanguage.getText("Độ ẩm", "Humidity"),
                            "${_weatherData!["main"]["humidity"]}%",
                          ),
                          _buildInfoColumn(
                            AppLanguage.getText("Gió", "Wind"),
                            "${UnitSettings.convertWindSpeed(_weatherData!["wind"]["speed"]).round()} ${UnitSettings.windSpeedSymbol()}",
                          ),
                          _buildInfoColumn(
                            AppLanguage.getText("Áp suất", "Pressure"),
                            "${_weatherData!["main"]["pressure"]} hPa",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
