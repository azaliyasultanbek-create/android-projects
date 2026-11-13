import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AZI Cosmetics',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF9F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB76E79),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF9F8),
          foregroundColor: Color(0xFF3D3032),
          centerTitle: true,
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}
