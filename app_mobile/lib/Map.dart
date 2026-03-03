import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MAP extends StatefulWidget {
  const MAP({Key? key}) : super(key: key);

  @override
  State<MAP> createState() => _MAPState();
}

class _MAPState extends State<MAP> {
  LatLng selectedPosition = LatLng(21.0285, 105.8542);
  String weatherInfo = "Nhấn vào bản đồ để xem thời tiết";

  Future<void> fetchWeather(double lat, double lon) async {
    String apiKey = "21e22af1cab731edfd013dcefac288d5";

    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double temp = data['main']['temp'];
      String description = data['weather'][0]['description'];

      setState(() {
        weatherInfo = "🌡 $temp°C\n☁ $description";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
