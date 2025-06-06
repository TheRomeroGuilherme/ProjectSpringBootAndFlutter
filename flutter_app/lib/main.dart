import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter API Demo',
      home: UserForm(),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();

  Future<void> cadastrarUsuario() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nomeCompleto': nomeController.text,
        'cpf': cpfController.text,
        'dataNascimento': '2000-01-01',
        'sexo': 'M',
      }),
    );

    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome Completo'),
            ),
            TextField(
              controller: cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cadastrarUsuario,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
