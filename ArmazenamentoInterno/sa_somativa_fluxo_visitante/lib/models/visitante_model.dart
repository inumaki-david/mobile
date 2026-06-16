class Visitante {
  int? id;
  String nome;
  String documento;
  String dataNascimento; // Regra: Data de Nascimento ao invés de idade
  String endereco;
  String tipo; // Regra: Visitante ou Prestador de Serviço

  Visitante({
    this.id,
    required this.nome,
    required this.documento,
    required this.dataNascimento,
    required this.endereco,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'data_nascimento': dataNascimento,
      'endereco': endereco,
      'tipo': tipo,
    };
  }

  factory Visitante.fromMap(Map<String, dynamic> map) {
    return Visitante(
      id: map['id'],
      nome: map['nome'],
      documento: map['documento'],
      dataNascimento: map['data_nascimento'],
      endereco: map['endereco'],
      tipo: map['tipo'],
    );
  }
}