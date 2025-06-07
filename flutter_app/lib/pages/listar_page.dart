// Conteúdo para: lib/pages/listar_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/models/usuario_model.dart';
import 'package:flutter_app/pages/cadastro_page.dart';
import 'package:flutter_app/services/api_service.dart';

// O NOME DA CLASSE FOI ALTERADO AQUI
class ListarPage extends StatefulWidget {
  const ListarPage({super.key});

  @override
  // E AQUI
  State<ListarPage> createState() => _ListarPageState();
}

// E AQUI
class _ListarPageState extends State<ListarPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Usuario>> _funcionarios;

  @override
  void initState() {
    super.initState();
    _refreshFuncionarioList();
  }

  void _refreshFuncionarioList() {
    setState(() {
      _funcionarios = _apiService.getUsuarios();
    });
  }

  void _navigateToCadastro([Usuario? usuario]) async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage(usuario: usuario)),
    );

    if (result == true) {
      _refreshFuncionarioList();
    }
  }

  void _excluirFuncionario(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir este funcionário?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _apiService.excluirUsuario(id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionário excluído com sucesso!')));
                  _refreshFuncionarioList();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Funcionários'),
        backgroundColor: const Color(0xFFB4B0FF),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _funcionarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum funcionário cadastrado.'));
          }
          final funcionarios = snapshot.data!;
          return ListView.builder(
            itemCount: funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = funcionarios[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(funcionario.nomeCompleto),
                  subtitle: Text('CPF: ${funcionario.cpf}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToCadastro(funcionario),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _excluirFuncionario(funcionario.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCadastro(),
        backgroundColor: const Color(0xFFB4B0FF),
        child: const Icon(Icons.add),
      ),
    );
  }
}