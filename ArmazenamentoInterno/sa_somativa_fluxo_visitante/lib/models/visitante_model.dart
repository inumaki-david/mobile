class Visitante {
  int? id;
  String nome;
  String documento;
  int idade;
  String endereco;

  Visitante({
    this.id,
    required this.nome,
    required this.documento,
    required this.idade,
    required this.endereco,
  });

  // Converte um objeto Visitante para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'idade': idade,
      'endereco': endereco,
    };
  }

  // Constrói um objeto Visitante a partir de um Map 
  factory Visitante.fromMap(Map<String, dynamic> map) {
    return Visitante(
      id: map['id'],
      nome: map['nome'],
      documento: map['documento'],
      idade: map['idade'],
      endereco: map['endereco'],
    );
  }
}