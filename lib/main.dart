import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphql_config.dart';

import 'CompanyListScreen.dart';
import 'AppColors.dart';
import 'LoginScreen.dart';
import 'OtpScreen.dart';
import 'TrastedScreen.dart';
import 'HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return GraphQLProvider(
      client: GraphQLConfig.graphInit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) =>
              LoginScreen(isDark: isDark, onThemeChange: toggleTheme),
          '/otp': (context) =>
              OtpScreen(isDark: isDark, onThemeChange: toggleTheme),
          '/company': (context) =>
              CompanyListScreen(isDark: isDark, onThemeChange: toggleTheme),
          '/home': (context) =>
              HomePage(isDark: isDark, onThemeChange: toggleTheme),
        },
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _navigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('islogin') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030915),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF052874), Color(0xFF030915)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            FadeTransition(
              opacity: _animation,
              child: Image.asset('assets/logo.webp', width: 220),
            ),
            const Spacer(),
            const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
