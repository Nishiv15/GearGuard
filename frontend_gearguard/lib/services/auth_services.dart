import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://localhost:5000/api";

  /// ================= SIGNUP =================
  static Future<String?> signup({
    required String companyName,
    required String name,
    required String email,
    required String password,
    required String repassword,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "companyName": companyName,
        "name": name,
        "email": email,
        "password": password,
        "repassword": repassword,
      }),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return null; // success
    } else {
      final data = jsonDecode(res.body);
      return data["message"] ?? "Signup failed";
    }
  }

  /// ================= LOGIN =================
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["token"]; // JWT token
    } else {
      final data = jsonDecode(res.body);
      return data["message"] ?? "Login failed";
    }
  }

  static void logout() {}
}
