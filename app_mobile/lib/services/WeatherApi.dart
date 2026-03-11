import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_mobile/Language.dart';
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