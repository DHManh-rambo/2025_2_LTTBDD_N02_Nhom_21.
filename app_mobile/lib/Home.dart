import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ManHinhGPS(), debugShowCheckedModeBanner: false));
}

class ManHinhGPS extends StatelessWidget {
  const ManHinhGPS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/home.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Menu(),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      ChiSo(),
                      SizedBox(height: 20),
                      ThongTin(),
                      SizedBox(height: 20),
                      DuBaoTheoGio(),
                      SizedBox(height: 20),
                      DuBaoTheoNgay(),
                      SizedBox(height: 20),
                      ThongTinChiTiet(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hà Nội",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Việt Nam",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Icon(Icons.menu, color: Colors.white),
        ],
      ),
    );
  }
}

class ThongTin extends StatelessWidget {
  const ThongTin({super.key});

  Widget item(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          item(Icons.water_drop, "Độ ẩm", "65%"),
          item(Icons.air, "Gió", "12 km/h"),
          item(Icons.remove_red_eye, "Tầm nhìn", "10 km"),
          item(Icons.speed, "Áp suất", "1013 mb"),
        ],
      ),
    );
  }
}

class ChiSo extends StatelessWidget {
  const ChiSo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DuBaoTheoGio extends StatelessWidget {
  const DuBaoTheoGio({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DuBaoTheoNgay extends StatelessWidget {
  const DuBaoTheoNgay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ThongTinChiTiet extends StatelessWidget {
  const ThongTinChiTiet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
