import 'package:flutter/material.dart';
import 'AppColors.dart';

class SolveScreen extends StatelessWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const SolveScreen({
    super.key,
    required this.isDark,
    required this.onThemeChange,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getBackgroundColor(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 50,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.help_center_outlined,
                      size: 80,
                      color: Colors.lightBlueAccent,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Help & Support",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Having trouble logging in? Please contact our support team or check your internet connection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Support Email: support@freeli.com",
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => onThemeChange(false),
                          icon: const Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onThemeChange(true),
                          icon: const Icon(
                            Icons.nightlight_round,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
