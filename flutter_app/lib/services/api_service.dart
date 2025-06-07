// Conteúdo completo e corrigido para: lib/services/api_service.dart

import 'package:flutter_app/models/usuario_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = "http://localhost:8080";

  Future<void> cadastrarUsuario(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao cadastrar usuário: ${response.body}');
    }
  }

  // ✅ MÉTODO PARA LISTAR (Read) - IMPLEMENTADO
  Future<List<Usuario>> getUsuarios() async {
    final response = await http.get(Uri.parse('$_baseUrl/usuarios'));

    if (response.statusCode == 200) {
      // Usamos utf8.decode para garantir a correta interpretação de caracteres especiais (acentos, etc.)
      final String responseBody = utf8.decode(response.bodyBytes);
      // Decodifica a string JSON para uma lista dinâmica
      final List<dynamic> body = jsonDecode(responseBody);
      // Converte cada item da lista em um objeto Usuario usando o método de fábrica
      final List<Usuario> usuarios = body.map((dynamic item) => Usuario.fromJson(item)).toList();
      return usuarios;
    } else {
      // Se a resposta não for 200, lança um erro.
      throw Exception('Falha ao carregar a lista de usuários.');
    }
  }

  // MÉTODO para ATUALIZAR (Update)
  Future<void> atualizarUsuario(int id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/usuarios/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(userData),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar usuário: ${response.body}');
    }
  }

  // MÉTODO para DELETAR (Delete)
  Future<void> excluirUsuario(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/usuarios/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir usuário');
    }
  }

  // Você mencionou a exclusão por CPF, podemos adicionar esse método também
  // se ele estiver implementado no seu backend.
  Future<void> excluirUsuarioPorCpf(String cpf) async {
     final response = await http.delete(Uri.parse('$_baseUrl/usuarios/cpf/$cpf'));
     if (response.statusCode != 204) { // DELETE por CPF retorna 204 No Content
       throw Exception('Falha ao excluir usuário por CPF');
     }
  }
}