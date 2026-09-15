// Classe Modelo que representa os campos exigidos no escopo do projeto.
// Facilita a conversão de dados entre o Flutter e o SQLite.
class Registro {
  final int? id;
  final String dataHora;
  final double latitude;
  final double longitude;
  final String observacao;
  final String caminhoFoto;

  Registro({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.observacao,
    required this.caminhoFoto,
  });

  // Converte o objeto Dart para um Map (formato JSON-like) para inserção no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora': dataHora,
      'latitude': latitude,
      'longitude': longitude,
      'observacao': observacao,
      'caminho_da_foto': caminhoFoto,
    };
  }
}