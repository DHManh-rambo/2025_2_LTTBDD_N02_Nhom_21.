import 'package:flutter/material.dart';
class UnitSettings {

  
  static String temperature = "C";

  
  static String windSpeed = "MS";


  
  static double convertTemperature(double tempC) {
    if (temperature == "F") {
      return tempC * 9 / 5 + 32;
    }
    return tempC;
  }

  static String temperatureSymbol() {
    if (temperature == "F") {
      return "°F";
    }
    return "°C";
  }
  static double convertWindSpeed(double windMs) {
    if (windSpeed == "KMH") {
      return windMs * 3.6;
    }
    return windMs;
  }
  static String windSpeedSymbol() {
    if (windSpeed == "KMH") {
      return "km/h";
    }
    return "m/s";
  }
}

