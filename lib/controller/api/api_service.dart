import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/modelScreema_mutation.dart';

class ApiServer {
  final String apiUrl = "https://caapicdn02.freeli.io/workfreeli";

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "query": loginMutation,
        "variables": {"email": email, "password": password, "companyId": null},
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['errors'] != null && responseData['errors'].isNotEmpty) {
        throw Exception(
          responseData['errors'][0]['message'] ?? "Unknown API Error",
        );
      }

      return responseData['data']['login'] as Map<String, dynamic>;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }
}
