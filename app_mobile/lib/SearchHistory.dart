import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String key = "search_history";

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> saveHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, history);
  }

  static Future<void> addItem(String city) async {
    final history = await getHistory();

    history.remove(city);
    history.insert(0, city);

    if (history.length > 5) {
      history.removeLast();
    }

    await saveHistory(history);
  }
}