import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';

class MAP extends StatefulWidget {
  const MAP({Key? key}) : super(key: key);

  @override
  State<MAP> createState() => _MAPState();
}

class _MAPState extends State<MAP> {
  LatLng selectedPosition = LatLng(21.0285, 105.8542);
  String weatherInfo = AppLanguage.getText(
    "Nhấn vào bản đồ để xem thời tiết",
    "Tap on the map to see weather",
  );

  Future<void> fetchWeather(double lat, double lon) async {
    String apiKey = "21e22af1cab731edfd013dcefac288d5";

    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double temp = UnitSettings.convertTemperature(data['main']['temp']);
      String description = data['weather'][0]['description'];

      setState(() {
        weatherInfo =
            "${AppLanguage.getText("Nhiệt độ", "Temperature")}: ${temp.round()}${UnitSettings.temperatureSymbol()}\n"
            "${AppLanguage.getText("Thời tiết", "Weather")}: $description";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.getText("Bản đồ thời tiết", "Weather Map")),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedPosition,
              initialZoom: 13,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedPosition = point;
                });
                fetchWeather(point.latitude, point.longitude);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedPosition,
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, size: 40, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                weatherInfo,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
