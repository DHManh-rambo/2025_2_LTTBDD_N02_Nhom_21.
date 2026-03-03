import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
      appBar: AppBar(title: const Text("Biểu đồ thời tiết"), centerTitle: true),

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
                    child: const Text("24h"),
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
                    child: const Text("7 ngày"),
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
                    child: const Text("Mưa"),
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
                border: Border.all(),
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
      (index) => FlSpot((index + 1).toDouble(), data[index]),
    );
  }

  Widget GetDescription() {
    if (selectedType == "24h") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Biểu đồ thể hiện nhiệt độ thay đổi trong 24 giờ gần nhất."),
          SizedBox(height: 4),
          Text("Chú Thích.", style: TextStyle(color: Colors.grey)),
          Text(
            "trục X: thể hiện số ngày từ 1 -> 24h. ",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "trục Y: thể hiện nhiệt độ (độ C). ",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    } else if (selectedType == "7day") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Biểu đồ thể hiện nhiệt độ thay đổi trong 7 ngày gần nhất."),
          SizedBox(height: 4),
          Text("Chú Thích.", style: TextStyle(color: Colors.grey)),
          Text(
            "trục X: thể hiện số ngày từ 1 -> 7. ",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "trục Y: thể hiện nhiệt độ (độ C). ",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Biểu đồ thể hiện lượng mưa trong 7 ngày gần nhất (mm)."),
          SizedBox(height: 4),
          Text("Chú Thích.", style: TextStyle(color: Colors.grey)),
          Text(
            "trục X: thể hiện số ngày từ 1 -> 7. ",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "trục Y: thể hiện lượng mưa(mm). ",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    }
  }
}
