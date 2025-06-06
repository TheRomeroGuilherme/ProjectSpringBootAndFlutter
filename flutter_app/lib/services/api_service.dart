import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:8080"; // Use 10.0.2.2 para emulador Android

  Future<void> cadastrarUsuario(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao cadastrar usuário: ${response.body}');
    }
  }
}