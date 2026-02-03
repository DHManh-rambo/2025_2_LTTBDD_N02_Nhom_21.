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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/Welcome.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),

            //  CHILD 1: mặt trời + chữ
            Column(
              children: [
                const Icon(
                  Icons.wb_sunny,
                  size: 100,
                  color: Color.fromARGB(255, 230, 251, 8),
                ),
                const SizedBox(height: 10),

                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 94, 173, 238),
                      Color.fromARGB(255, 246, 234, 130),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'WeatherForecast',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            //  CHILD 2: dòng chữ giới thiệu
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Dự báo thời tiết chính xác, cập nhật mọi lúc mọi nơi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 246, 234, 130),
                ),
              ),
            ),

            const SizedBox(height: 150),

            // CHILD 3: button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 234, 211, 181),
                minimumSize: const Size(260, 65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                elevation: 6,
              ),
              child: const Text(
                'Bắt đầu ngay',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 20, 145, 164),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
