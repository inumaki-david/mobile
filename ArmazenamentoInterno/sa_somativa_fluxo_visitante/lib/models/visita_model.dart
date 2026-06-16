class Visita {
  int? id;
  int visitanteId;
  String dataEntrada;
  String? dataSaida;
  String motivo;
  String unidadeDestino; // Regra: Unidade/Destino no condomínio

  Visita({
    this.id,
    required this.visitanteId,
    required this.dataEntrada,
    this.dataSaida,
    required this.motivo,
    required this.unidadeDestino,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visitante_id': visitanteId,
      'data_entrada': dataEntrada,
      'data_saida': dataSaida,
      'motivo': motivo,
      'unidade_destino': unidadeDestino,
    };
  }

  factory Visita.fromMap(Map<String, dynamic> map) {
    return Visita(
      id: map['id'],
      visitanteId: map['visitante_id'],
      dataEntrada: map['data_entrada'],
      dataSaida: map['data_saida'],
      motivo: map['motivo'],
      unidadeDestino: map['unidade_destino'],
    );
  }
}