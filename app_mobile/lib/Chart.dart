import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/Unit.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  String selectedType = "24h";

  final List<double> hourlyTemp = [
    26,
    26,
    25,
    25,
    24,
    24,
    25,
    27,
    29,
    31,
    32,
    33,
    34,
    34,
    33,
    32,
    30,
    29,
    28,
    27,
    27,
    26,
    26,
    26,
  ];

  final List<double> weeklyTemp = [30, 32, 31, 29, 28, 27, 26];

  final List<double> rainData = [2, 5, 0, 10, 3, 7, 1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.getText("Biểu đồ thời tiết", "Weather Chart")),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = "24h";
                      });
                    },
                    child: Text(AppLanguage.getText("24 giờ", "24 Hours")),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = "7day";
                      });
                    },
                    child: Text(AppLanguage.getText("7 ngày", "7 Days")),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = "rain";
                      });
                    },
                    child: Text(AppLanguage.getText("Mưa", "Rain")),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: CreateSpots(),
                      isCurved: false,
                      barWidth: 2,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            GetDescription(),
          ],
        ),
      ),
    );
  }

  List<FlSpot> CreateSpots() {
    List<double> data;

    if (selectedType == "24h") {
      data = hourlyTemp;
    } else if (selectedType == "7day") {
      data = weeklyTemp;
    } else {
      data = rainData;
    }

    return List.generate(
      data.length,
      (index) => FlSpot(
        (index + 1).toDouble(),
        UnitSettings.convertTemperature(data[index]),
      ),
    );
  }

  Widget GetDescription() {
    if (selectedType == "24h") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLanguage.getText(
              "Biểu đồ thể hiện nhiệt độ thay đổi trong 24 giờ gần nhất.",
              "This chart shows temperature changes over the last 24 hours.",
            ),
          ),
          SizedBox(height: 4),
          Text(
            AppLanguage.getText("Chú thích.", "Legend"),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            AppLanguage.getText(
              "Trục X: thể hiện số giờ từ 1 -> 24.",
              "X axis: shows hours from 1 -> 24.",
            ),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            AppLanguage.getText(
              "Trục Y: thể hiện nhiệt độ (${UnitSettings.temperatureSymbol()}).",
              "Y axis: shows temperature (${UnitSettings.temperatureSymbol()}).",
            ),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    } else if (selectedType == "7day") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLanguage.getText(
              "Biểu đồ thể hiện nhiệt độ thay đổi trong 7 ngày gần nhất.",
              "This chart shows temperature changes over the last 7 days.",
            ),
          ),
          SizedBox(height: 4),
          Text(
            AppLanguage.getText("Chú thích.", "Legend"),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            AppLanguage.getText(
              "Trục X: thể hiện số ngày từ 1 -> 7.",
              "X axis: shows days from 1 -> 7.",
            ),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            AppLanguage.getText(
              "Trục Y: thể hiện nhiệt độ (${UnitSettings.temperatureSymbol()}).",
              "Y axis: shows temperature (${UnitSettings.temperatureSymbol()}).",
            ),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLanguage.getText(
              "Biểu đồ thể hiện nhiệt độ thay đổi trong 7 ngày gần nhất.",
              "This chart shows temperature changes over the last 7 days.",
            ),
          ),
          SizedBox(height: 4),
          Text(
            AppLanguage.getText("Chú thích.", "Legend"),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            AppLanguage.getText(
              "Trục X: thể hiện số ngày từ 1 -> 7.",
              "X axis: shows days from 1 -> 7.",
            ),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            AppLanguage.getText(
              "Biểu đồ thể hiện lượng mưa trong 7 ngày gần nhất (mm).",
              "This chart shows rainfall over the last 7 days (mm).",
            ),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    }
  }
}
