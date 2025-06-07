import 'package:flutter/material.dart';
import 'package:flutter_app/pages/listar_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cor de fundo lilás, extraída da imagem
    const Color lavenderColor = Color(0xFFB4B0FF);

    return Scaffold(
      backgroundColor: lavenderColor,
      body: Center(
        // Card branco centralizado
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
            width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
            constraints: const BoxConstraints(maxWidth: 500), // Largura máxima para telas grandes
            child: Column(
              mainAxisSize: MainAxisSize.min, // A coluna se ajusta ao conteúdo
              children: <Widget>[
                // Título "Bem Vindo ao Projeto"
                const Text(
                  'Bem Vindo ao Projeto',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20), // Espaçamento

                // Texto descritivo
                const Text(
                  'Neste projeto estou usando o Flutter como exibição de web pages, para começar clique no botão "cadastrar"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5, // Espaçamento entre linhas
                  ),
                ),
                const SizedBox(height: 30), // Espaçamento

                // Botão "cadastrar"
                ElevatedButton(
                  onPressed: () {
                    // ALTERE A NAVEGAÇÃO AQUI
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const ListarPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lavenderColor, // Mesma cor do fundo
                    foregroundColor: Colors.white, // Texto branco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Bordas bem arredondadas
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}