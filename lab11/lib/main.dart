import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode =
      prefs.getBool('app_theme_dark_mode') ?? false;
  final String username =
      prefs.getString('user_display_name') ?? 'Guest User';
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(
        isDarkMode: isDarkMode,
        username: username,
      ),
    ),
  );
}
class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final String username;
  const MyApp({
    super.key,
    required this.isDarkMode,
    required this.username,
  });
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late String username;
  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    username = widget.username;
  }
  Future<void> toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app_theme_dark_mode', value);
  }
  Future<void> updateUsername(String value) async {
    final newUsername =
        value.trim().isEmpty ? 'Guest User' : value.trim();
    setState(() {
      username = newUsername;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_display_name', newUsername);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AZI Cosmetics',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF9F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB76E79),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF9F8),
          foregroundColor: Color(0xFF3D3032),
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB76E79),
          brightness: Brightness.dark,
        ),
      ),
      home: CatalogScreen(
        isDarkMode: isDarkMode,
        username: username,
        onThemeChanged: toggleTheme,
        onUsernameSaved: updateUsername,
      ),
    );
  }
}
