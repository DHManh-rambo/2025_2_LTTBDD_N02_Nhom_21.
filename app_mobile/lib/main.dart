import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherStart(),
    );
  }
}

class WeatherStart extends StatelessWidget {
  const WeatherStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // top spacing
            const SizedBox(height: 100),

            //  CHILD 1: mặt trời + chữ
            Column(
              children: const [
                Icon(Icons.wb_sunny, size: 80),
                SizedBox(height: 10),
                Text('WeatherForecast', style: TextStyle(fontSize: 24)),
              ],
            ),

            const SizedBox(height: 20),

            //  CHILD 2: dòng chữ giới thiệu
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Dòng chữ giới thiệu ứng dụng thời tiết',
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // CHILD 3: button
            ElevatedButton(onPressed: () {}, child: const Text('Bắt đầu ngay')),

            const SizedBox(height: 40),

            //  CHILD 4: các icon nhỏ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.wb_sunny),
                Icon(Icons.cloud),
                Icon(Icons.beach_access),
                Icon(Icons.flash_on),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
