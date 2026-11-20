import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_item.dart';
class StorageService {
  static const String themeKey = 'app_theme_dark_mode';
  static const String usernameKey = 'user_display_name';
  static const String notesKey = 'notes_list';
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameKey, username);
  }
  static Future<String> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey) ?? 'Guest User';
  }
  static Future<void> saveNotes(List<NoteItem> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      notes.map((note) => note.toJson()).toList(),
    );
    await prefs.setString(notesKey, jsonString);
  }
  static Future<List<NoteItem>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(notesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final List<dynamic> decodedData = jsonDecode(jsonString);
    return decodedData.map((item) {
      return NoteItem.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}
