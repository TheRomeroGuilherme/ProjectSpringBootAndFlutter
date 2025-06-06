// Substitua todo o conteúdo de lib/main.dart por este

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/cadastro/cadastro_page.dart'; // Importa a nova página
import 'package:flutter_app/pages/login/login_page.dart';
import 'package:flutter_app/pages/listar/listar_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cadastro de Usuários',
      home: UserFormPage(), // Define a página do formulário como a tela inicial
    );
  }
}