import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_mobile/Language.dart';

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
              "Please enter a city name";
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
      appBar: AppBar(title: Text(AppLanguage.getText("Tìm kiếm", "Search")), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: AppLanguage.getText(
                    "Nhập tên thành phố...",
                    "Enter city name...",
                    ),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWeather,
                ),
              ),
              onSubmitted: (_) => _searchWeather(),
            ),

            SizedBox(height: 15),

            if (searchHistory.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLanguage.getText(
              "Lịch sử tìm kiếm:",
              "Search history:",
                ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchHistory[index]),
                      leading: Icon(Icons.history),
                      onTap: () {
                        _cityController.text = searchHistory[index];
                        _searchWeather();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],

            if (_isLoading) CircularProgressIndicator(),

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),

            if (_weatherData != null) ...[
              SizedBox(height: 20),

              Text(
                _weatherData!["name"],
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              Text(
                "${_weatherData!["main"]["temp"].round()}°C",
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.w200),
              ),

              Text(
                _weatherData!["weather"][0]["description"],
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumn(
                    AppLanguage.getText("Độ ẩm", "Humidity"),
                    "${_weatherData!["main"]["humidity"]}%",
                  ),
                  _buildInfoColumn(
                    AppLanguage.getText("Gió", "Wind"),
                    "${_weatherData!["wind"]["speed"]} m/s",
                  ),
                  _buildInfoColumn(
                    AppLanguage.getText("Áp suất", "Pressure"),
                    "${_weatherData!["main"]["pressure"]} hPa",
                  ),
                ],
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
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
