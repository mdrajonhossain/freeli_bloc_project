import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AppColors.dart';
import 'model/modelScreema_mutation.dart';

class CompanyListScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const CompanyListScreen({
    super.key,
    required this.isDark,
    required this.onThemeChange,
  });

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  bool isLoading = false;

  Future<void> _selectCompany(
    String companyId,
    String email,
    String password,
  ) async {
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
          },
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final loginData = responseData['data']['login'];

        print("Company Select Response: $loginData");

        if (loginData['status'] == true) {
          if (mounted) {
            Navigator.pushNamed(
              context,
              "/otp",
              arguments: {
                "email": email,
                "password": password,
                "companyId": companyId,
              },
            );
          }
        } else {
          _showError(loginData['message'] ?? "Selection failed");
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final List<dynamic> companiesData = args['companies'] ?? [];
    final String email = args['email'] ?? '';
    final String password = args['password'] ?? '';

    final bgColor = AppColors.getBackgroundColor(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Welcome back!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Please select a business account to continue",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 20),

            /// ================= LIST =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: companiesData.length,
                itemBuilder: (context, index) {
                  final company = companiesData[index];
                  final String companyName =
                      company['company_name'] ?? 'Unknown Company';
                  final String companyId = company['company_id'] ?? '';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      title: Text(
                        companyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 14,
                      ),

                      onTap: isLoading
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Selecting $companyName..."),
                                  duration: const Duration(milliseconds: 500),
                                ),
                              );
                              _selectCompany(companyId, email, password);
                            },
                    ),
                  );
                },
              ),
            ),

            /// ================= THEME SWITCH =================
            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => widget.onThemeChange(false),
                    icon: const Icon(Icons.wb_sunny, size: 28),
                    color: Colors.yellow,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => widget.onThemeChange(true),
                    icon: const Icon(Icons.nightlight_round, size: 28),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
