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
