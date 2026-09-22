import 'package:intl/intl.dart';

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

  // Converte um Map do SQLite para uma instância de Registro.
  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'] as int?,
      dataHora: map['data_hora'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      observacao: map['observacao'] as String? ?? '',
      caminhoFoto: map['caminho_da_foto'] as String? ?? '',
    );
  }

  // Converte o objeto Dart para um Map (formato JSON-like) para inserção no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'data_hora': dataHora,
      'latitude': latitude,
      'longitude': longitude,
      'observacao': observacao,
      'caminho_da_foto': caminhoFoto,
    };
  }

  // Retorna a data e hora formatada para o padrão brasileiro (ex: 22/09/2026 08:30)
  String get dataHoraFormatada {
    try {
      final parsed = DateTime.parse(dataHora);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(parsed);
    } catch (_) {
      return dataHora;
    }
  }

  // Retorna uma versão curta da data (ex: 22/09/2026)
  String get dataCurta {
    try {
      final parsed = DateTime.parse(dataHora);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (_) {
      return dataHora;
    }
  }

  // Retorna o horário (ex: 08:30)
  String get horarioFormatado {
    try {
      final parsed = DateTime.parse(dataHora);
      return DateFormat('HH:mm').format(parsed);
    } catch (_) {
      return '';
    }
  }
}