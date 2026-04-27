import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphql_config.dart';
import 'AppColors.dart';

class LoginScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const LoginScreen({
    super.key,
    required this.isDark,
    required this.onThemeChange,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool rememberMe = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscurePassword : false,
        style: const TextStyle(color: Colors.black87),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getBackgroundColor(widget.isDark);
    final secondaryTextColor = Colors.white70;

    return Mutation(
      options: MutationOptions(
        document: gql(GraphQLSchema.loginMutation),
        onCompleted: (dynamic data) async {
          if (data != null && data['login'] != null) {
            final loginData = data['login'];
            final email = emailController.text.trim();

            if (loginData['status'] == true) {
              final prefs = await SharedPreferences.getInstance();

              final token = loginData['session_token'] ?? loginData['token'];

              if (!context.mounted) return;

              if (loginData['next_step'] == "otp") {
                Navigator.pushNamed(
                  context,
                  "/otp",
                  arguments: {
                    "email": email,
                    "session_token": token,
                    "step": "otp",
                  },
                );
              } else if (loginData['next_step'] == "company") {
                Navigator.pushNamed(
                  context,
                  "/company",
                  arguments: {
                    "email": email,
                    "companies": loginData['companies'],
                    "session_token": token,
                    "step": "company",
                  },
                );
              }
            }
          }
        },
        onError: (OperationException? error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error?.graphqlErrors.isNotEmpty == true
                    ? error!.graphqlErrors.first.message
                    : "An error occurred",
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return Scaffold(
          backgroundColor: bgColor,

          /// ================= APPBAR =================
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => widget.onThemeChange(!widget.isDark),
                icon: Icon(
                  widget.isDark ? Icons.light_mode : Icons.dark_mode,
                  size: 20,
                ),
                color: Colors.white54,
              ),
            ],
          ),

          /// ================= BODY =================
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Center(child: Image.asset('assets/logo.webp', height: 55)),

                  const SizedBox(height: 35),

                  const Center(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      "Sign in to continue your workflow",
                      style: TextStyle(color: secondaryTextColor, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// EMAIL
                  _input(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 15),

                  /// PASSWORD
                  _input(
                    controller: passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 12),

                  /// OTP + FORGOT PASSWORD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Sign In With OTP",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// REMEMBER ME
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text(
                        "Remember Me",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// SIGN IN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (result?.isLoading ?? false) return;

                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter both email and password",
                                  ),
                                ),
                              );
                              return;
                            }

                            runMutation({
                              "email": email,
                              "password": password,
                              "deviceId": "mobile_app",
                              "step": "validate",
                            });
                          },
                          child: Center(
                            child: (result?.isLoading ?? false)
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// SIGN UP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
