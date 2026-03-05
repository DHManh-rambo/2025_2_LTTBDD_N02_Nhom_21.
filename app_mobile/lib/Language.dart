import 'package:flutter/material.dart';

class AppLanguage {
  static String current = "VI";

  static String getText(String vi, String en) {
    if (current == "VI") {
      return vi;
    } else {
      return en;
    }
  }
}
