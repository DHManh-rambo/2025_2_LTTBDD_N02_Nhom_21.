import 'package:flutter/material.dart';
import 'package:app_mobile/Language.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    String title;
    String content;

    if (AppLanguage.current == "VI") {
      title = "Thông tin nhóm";
      content =
          "Nhóm 21\n\n"
          "Dương Hùng Mạnh\n"
          "Mã Sinh Viên:23010597"
          "Nguyễn Đức Trọng\n"
          "Mã Sinh Viên:23010594";
    } else {
      title = "Group Information";
      content =
          "Group 21\n\n"
          "Duong Hung Manh\n"
          "Student Id:23010597\n"
          "Nguyen Duc Trong\n"
          "Student Id:2310594\n";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}