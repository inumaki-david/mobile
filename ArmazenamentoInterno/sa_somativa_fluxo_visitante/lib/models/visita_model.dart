class Visita {
  int? id;
  int visitanteId; // Chave estrangeira
  String dataEntrada;
  String? dataSaida; // Pode ser nulo se a visita ainda estiver em andamento
  String motivo;

  Visita({
    this.id,
    required this.visitanteId,
    required this.dataEntrada,
    this.dataSaida,
    required this.motivo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visitante_id': visitanteId,
      'data_entrada': dataEntrada,
      'data_saida': dataSaida,
      'motivo': motivo,
    };
  }

  factory Visita.fromMap(Map<String, dynamic> map) {
    return Visita(
      id: map['id'],
      visitanteId: map['visitante_id'],
      dataEntrada: map['data_entrada'],
      dataSaida: map['data_saida'],
      motivo: map['motivo'],
    );
  }
}