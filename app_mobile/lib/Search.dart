import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  List<String> _searchHistory = [];

  Future<void> _searchWeather() async {
    String city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng nhập tên thành phố";
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
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=vi";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = jsonDecode(response.body);
          _isLoading = false;

          if (!_searchHistory.contains(city)) {
            _searchHistory.insert(0, city);
          }
        });
      } else {
        setState(() {
          _errorMessage = "Không tìm thấy thành phố";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi kết nối, vui lòng thử lại";
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
      appBar: AppBar(title: Text("Tìm kiếm "), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: "Nhập tên thành phố...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWeather,
                ),
              ),
              onSubmitted: (_) => _searchWeather(),
            ),

            SizedBox(height: 15),

            if (_searchHistory.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lịch sử tìm kiếm:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchHistory[index]),
                      leading: Icon(Icons.history),
                      onTap: () {
                        _cityController.text = _searchHistory[index];
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
                    "Độ ẩm",
                    "${_weatherData!["main"]["humidity"]}%",
                  ),
                  _buildInfoColumn(
                    "Gió",
                    "${_weatherData!["wind"]["speed"]} m/s",
                  ),
                  _buildInfoColumn(
                    "Áp suất",
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
