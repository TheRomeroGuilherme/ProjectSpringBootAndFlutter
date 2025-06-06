import 'package:flutter/material.dart';
import 'services/api_service.dart'; // <-- IMPORTE O NOVO SERVIÇO


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
  final dataNascimentoController = TextEditingController();
  final apiService = ApiService();
  String? _sexoSelecionado;

  Future<void> cadastrarUsuario() async {
    final userData = {
      'nomeCompleto': nomeController.text,
      'cpf': cpfController.text,
      'dataNascimento': dataNascimentoController.text,
      'sexo': _sexoSelecionado,
    };

    try {
    await apiService.cadastrarUsuario(userData); // <-- CHAME O MÉTODO DO SERVIÇO
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
    );
    } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: ${e.toString()}')),
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
            // ADICIONE ESTE TEXTFIELD PARA DATA DE NASCIMENTO
            TextField(
              controller: dataNascimentoController,
              decoration: const InputDecoration(labelText: 'Data de Nascimento (AAAA-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            // ADICIONE ESTE DROPDOWN PARA SEXO
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
            // FIM DA ADIÇÃO
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
