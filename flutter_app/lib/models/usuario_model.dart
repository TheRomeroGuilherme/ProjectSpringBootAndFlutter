class Usuario {
  final int id;
  final String nomeCompleto;
  final String cpf;
  final String dataNascimento;
  final String sexo;
  final String? dataCadastro; // O '?' torna o campo opcional para evitar erros

  Usuario({
    required this.id,
    required this.nomeCompleto,
    required this.cpf,
    required this.dataNascimento,
    required this.sexo,
    this.dataCadastro,
  });

  // Este método especial "constrói" um objeto Usuario a partir de um mapa (JSON)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nomeCompleto: json['nomeCompleto'],
      cpf: json['cpf'],
      dataNascimento: json['dataNascimento'],
      sexo: json['sexo'],
      dataCadastro: json['dataCadastro'],
    );
  }
}