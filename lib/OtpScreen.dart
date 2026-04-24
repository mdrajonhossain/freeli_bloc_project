import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'AppColors.dart';
import 'model/modelScreema_mutation.dart';

class OtpScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const OtpScreen({
    super.key,
    required this.isDark,
    required this.onThemeChange,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  bool isLoading = false;

  String getOtp() => controllers.map((e) => e.text).join();

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> verifyOtp(
    String email,
    String password,
    String? companyId,
  ) async {
    final otpCode = getOtp();
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter full 6 digit OTP")));
      return;
    }

    setState(() => isLoading = true);
    const String apiUrl = "https://caapicdn02.freeli.io/workfreeli";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "query": loginMutation,
          "variables": {
            "email": email,
            "password": password,
            "companyId": companyId,
            "code": otpCode,
          },
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final loginData = responseData['data']['login'];

        if (loginData['status'] == true) {
          await _saveToken(loginData['token']);
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/home");
          }
        } else {
          _showError(loginData['message'] ?? "OTP verification failed");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void resendOtp() {}

  Widget otpBox(int index, double boxSize) {
    return SizedBox(
      width: boxSize,
      height: boxSize + 5,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final String email = args['email'] ?? '';
    final String password = args['password'] ?? '';
    final String? companyId = args['companyId'];

    final bgColor = AppColors.getBackgroundColor(widget.isDark);

    // 📱 responsive box size fix (IMPORTANT)
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = (screenWidth - 120) / 6; // perfect fit 6 boxes

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 80,
                        color: Colors.lightBlueAccent,
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Verification Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "A 6-digit code has been sent to your email.\nPlease enter it below to continue.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),

                      const SizedBox(height: 40),

                      /// 🔢 FIXED OTP ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: otpBox(i, boxSize),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      /// 🔁 RESEND
                      TextButton(
                        onPressed: resendOtp,
                        child: const Text(
                          "Didn't receive the code? Resend OTP",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                      ),

                      const SizedBox(height: 35),

                      /// 🔘 VERIFY BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: isLoading
                                  ? null
                                  : () => verifyOtp(email, password, companyId),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Verify & Continue",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      _buildThemeToggles(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeToggles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => widget.onThemeChange(false),
          icon: const Icon(Icons.wb_sunny),
          color: Colors.yellow,
        ),
        IconButton(
          onPressed: () => widget.onThemeChange(true),
          icon: const Icon(Icons.nightlight_round),
          color: Colors.white,
        ),
      ],
    );
  }
}
