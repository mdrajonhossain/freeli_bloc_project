import 'dart:convert';
import 'package:freeli/model/modelScreema_quary.dart';
import 'package:http/http.dart' as http;
import '../../model/modelScreema_mutation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServer {
  final String apiUrl = "http://172.16.3.94:4001/workfreeli";

  Future<Map<String, dynamic>> login({
    String? email,
    String? password,
    String? companyId,
    String? code,
    String? sessionToken,
    required String step,
    String deviceId = "android",
  }) async {
    Map<String, dynamic> variables = {"step": step, "deviceId": deviceId};

    if (step == "validate") {
      variables.addAll({"email": email, "password": password});
    } else if (step == "otp") {
      variables.addAll({
        "email": email,
        "code": code,
        "sessionToken": sessionToken,
      });
    } else if (step == "company") {
      variables.addAll({
        "email": email,
        "companyId": companyId,
        "sessionToken": sessionToken,
      });
    } else {
      throw Exception("Invalid step: $step");
    }

    variables.removeWhere((key, value) => value == null);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": loginMutation, "variables": variables}),
    );

    if (response.statusCode != 200) {
      throw Exception("HTTP Error: ${response.statusCode}");
    }

    final responseData = jsonDecode(response.body);

    if (responseData['errors'] != null) {
      throw Exception(responseData['errors'][0]['message']);
    }

    final loginData = responseData['data']['login'];

    if (loginData['status'] == true) {
      return Map<String, dynamic>.from(loginData);
    } else {
      throw Exception(loginData['message'] ?? "Login failed");
    }
  }
}
