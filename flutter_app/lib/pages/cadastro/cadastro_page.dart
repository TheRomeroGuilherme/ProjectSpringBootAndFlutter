// Crie a pasta 'pages' dentro de 'lib' e, dentro dela, este novo arquivo.
// Conteúdo para lib/pages/user_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/services/api_service.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  // Controladores para os campos do formulário
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  String? _sexoSelecionado;

  final ApiService apiService = ApiService();
  bool _isLoading = false;

  Future<void> _cadastrarUsuario() async {
    if (_sexoSelecionado == null || dataNascimentoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userData = {
      'nomeCompleto': nomeController.text,
      'cpf': cpfController.text,
      'dataNascimento': dataNascimentoController.text,
      'sexo': _sexoSelecionado,
    };

    try {
      await apiService.cadastrarUsuario(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      // Limpa os campos após o sucesso
      nomeController.clear();
      cpfController.clear();
      dataNascimentoController.clear();
      setState(() {
        _sexoSelecionado = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dataNascimentoController,
              decoration: const InputDecoration(labelText: 'Data de Nascimento (AAAA-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            DropdownButtonFormField<String>(
              value: _sexoSelecionado,
              hint: const Text('Sexo'),
              onChanged: (String? newValue) {
                setState(() {
                  _sexoSelecionado = newValue;
                });
              },
              items: <String>['M', 'H'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'M' ? 'Feminino' : 'Masculino'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _cadastrarUsuario,
                    child: const Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}