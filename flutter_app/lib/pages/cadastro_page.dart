import 'package:flutter/material.dart';
import 'package:flutter_app/models/usuario_model.dart';
import 'package:flutter_app/services/api_service.dart'; 
import 'package:flutter_app/pages/listar_page.dart'; 
import 'package:intl/intl.dart';

class CadastroPage extends StatefulWidget {
  final Usuario? usuario;

  const CadastroPage({super.key, this.usuario});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  String? _sexo;
  bool _isLoading = false;
  final _apiService = ApiService();

  bool get isEditing => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final user = widget.usuario!;
      _nomeController.text = user.nomeCompleto;
      _cpfController.text = user.cpf;
      _dataNascimentoController.text = user.dataNascimento;
      _sexo = user.sexo;
    }
  }

  Future<void> _submitForm() async {
    if (_nomeController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _dataNascimentoController.text.isEmpty ||
        _sexo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha todos os campos.')));
      return;
    }
    setState(() => _isLoading = true);

    final userData = {
      'nomeCompleto': _nomeController.text,
      'cpf': _cpfController.text,
      'dataNascimento': _dataNascimentoController.text,
      'sexo': _sexo,
    };

    try {
      if (isEditing) {
        await _apiService.atualizarUsuario(widget.usuario!.id, userData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionário atualizado com sucesso!')));
        Navigator.of(context).pop(true); 
      }else {
        await _apiService.cadastrarUsuario(userData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionário cadastrado com sucesso!')));

        // Verifique se aqui está chamando a 'ListarPage'
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ListarPage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dataNascimentoController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lavenderColor = Color(0xFFB4B0FF);
    return Scaffold(
      backgroundColor: lavenderColor,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 8.0,
            child: Container(
              padding: const EdgeInsets.all(30.0),
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cadastro',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Para começar vamos para o seu cadastro!',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 30),
                  _buildTextField(_nomeController, 'Nome completo:'),
                  const SizedBox(height: 15),
                  _buildTextField(_cpfController, 'Cpf:', isNumeric: true),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDateField(),
                      ),
                      const SizedBox(width: 20),
                      _buildSexoSelector(),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildActionButtons(lavenderColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data de nascimento:',
            style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          controller: _dataNascimentoController,
          readOnly: true,
          onTap: _selectDate,
          decoration: InputDecoration(
            hintText: 'AAAA-MM-DD',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    const BorderSide(color: Color(0xFFB4B0FF), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    const BorderSide(color: Color(0xFFB4B0FF), width: 2.5)),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTextField(TextEditingController controller, String label, {String? hint, bool isNumeric = false}) {
    const Color lavenderColor = Color(0xFFB4B0FF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint ?? label,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: lavenderColor, width: 1.5)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: lavenderColor, width: 2.5)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSexoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('sexo:', style: TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: [
            Radio<String>(
                value: 'H',
                groupValue: _sexo,
                onChanged: (v) => setState(() => _sexo = v)),
            const Text('Homem'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
                value: 'M',
                groupValue: _sexo,
                onChanged: (v) => setState(() => _sexo = v)),
            const Text('Mulher'),
          ],
        ),
      ],
    );
  }

Widget _buildActionButtons(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text('voltar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm, 
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
              : Text(isEditing ? 'Atualizar' : 'Cadastrar'),
        ),
      ],
    );
  }
}

