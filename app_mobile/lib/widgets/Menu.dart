import 'package:flutter/material.dart';
import 'package:app_mobile/Search.dart';
import 'package:app_mobile/Chart.dart';
import 'package:app_mobile/Map.dart';
import 'package:app_mobile/Setting.dart';
import 'package:app_mobile/Language.dart';
import 'package:app_mobile/main.dart';
class Menu extends StatefulWidget {
  final List<String> searchHistory;
  final Function(String)? onCityChanged;
  final VoidCallback? onSearchCompleted;
  final VoidCallback? onLanguageChanged;

  const Menu({
    super.key,
    required this.searchHistory,
    this.onCityChanged,
    this.onSearchCompleted,
    this.onLanguageChanged,
  });
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String selectedCity = "Hanoi";

  @override
  void didUpdateWidget(covariant Menu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchHistory.isNotEmpty &&
        !widget.searchHistory.contains(selectedCity)) {
      setState(() {
        selectedCity = widget.searchHistory.first;
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedCity = value;
              });
              widget.onCityChanged?.call(value);
            },
            itemBuilder: (context) {
              if (widget.searchHistory.isEmpty) {
                return [PopupMenuItem(value: "Hà Nội", child: Text("Hà Nội"))];
              }

              return widget.searchHistory.map((city) {
                return PopupMenuItem(value: city, child: Text(city));
              }).toList();
            },
            child: Row(
              children: [
                Text(
                  selectedCity,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
              size: 32,
            ),
            color: Theme.of(context).cardColor,
            onSelected: (value) async {
              if (value == 'home') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherStart()),
                  (route) => false,
                );
              }
              if (value == 'settings') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );

                if (mounted) {
                  widget.onLanguageChanged?.call();
                }
              }
              if (value == 'search') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Search()),
                );
                if (mounted) {
                  setState(() {});
                  widget.onSearchCompleted?.call();
                }
              }
              if (value == 'map') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MAP()),
                );
              }
              if (value == 'chart') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chart()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'home',
                  child: Text(
                    AppLanguage.getText("Trang chủ", "Home"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'search',
                  child: Text(
                    AppLanguage.getText("Tìm kiếm", "Search"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'map',
                  child: Text(
                    AppLanguage.getText("Bản đồ", "Map"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'chart',
                  child: Text(
                    AppLanguage.getText("Biểu đồ", "Chart"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    AppLanguage.getText("Cài đặt", "Settings"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}