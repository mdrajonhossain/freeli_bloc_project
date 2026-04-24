import 'package:flutter/material.dart';
import 'CompanyListScreen.dart';
import 'LoginScreen.dart';
import 'OtpScreen.dart';
import 'SolveScreen.dart';
import 'HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  void toggleTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) =>
            LoginScreen(isDark: isDark, onThemeChange: toggleTheme),
        "/otp": (context) =>
            OtpScreen(isDark: isDark, onThemeChange: toggleTheme),
        "/company": (context) =>
            CompanyListScreen(isDark: isDark, onThemeChange: toggleTheme),
        "/home": (context) =>
            HomePage(isDark: isDark, onThemeChange: toggleTheme),
        "/solve": (context) =>
            SolveScreen(isDark: isDark, onThemeChange: toggleTheme),
      },
    );
  }
}
