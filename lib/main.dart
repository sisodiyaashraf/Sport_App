import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_app/provider/theme_provider.dart';
import 'package:sports_app/widgets/bottom_navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const SportsApp(),
    ),
  );
}

class SportsApp extends StatelessWidget {
  const SportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedTheme(
      data: themeProvider.isDarkMode ? _darkTheme() : _lightTheme(),
      duration: const Duration(milliseconds: 400), // smooth animation
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sports Skills",
        theme: _lightTheme(),
        darkTheme: _darkTheme(),
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const BottomNavBarr(),
      ),
    );
  }

  ThemeData _lightTheme() => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      );

  ThemeData _darkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.teal,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      );
}
