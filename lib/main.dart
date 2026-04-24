import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CompanyListScreen.dart';
import 'LoginScreen.dart';
import 'OtpScreen.dart';
import 'TrastedScreen.dart';
import 'HomePage.dart';

import 'controller/stateBloc/LoginBloc.dart';

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
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LoginBloc())],
      child: MaterialApp(
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
        },
      ),
    );
  }
}
