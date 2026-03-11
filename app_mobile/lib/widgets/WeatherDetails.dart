import 'package:flutter/material.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';

class ThongTinChiTiet extends StatelessWidget {
  const ThongTinChiTiet({super.key});

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
      width: 140,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFF000), Color(0xFFFFA500)],
            ).createShader(bounds),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            sub,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
