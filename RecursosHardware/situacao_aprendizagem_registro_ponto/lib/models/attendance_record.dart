import 'api_exception.dart';

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
  });

  final String id;
  final String employeeId;
  final String type;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double distanceMeters;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final timestamp = DateTime.tryParse(json['timestamp']?.toString() ?? '');
    final latitude = (json['latitude'] as num?)?.toDouble();
    final longitude = (json['longitude'] as num?)?.toDouble();
    final distanceMeters = (json['distanceMeters'] as num?)?.toDouble();

    if (timestamp == null ||
        latitude == null ||
        longitude == null ||
        distanceMeters == null) {
      throw const ApiException('A API retornou um registro de ponto inválido.');
    }

    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Registro',
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      distanceMeters: distanceMeters,
    );
  }
}

String attendanceTypeForIndex(int index) {
  const types = [
    'Entrada',
    'Início do intervalo',
    'Retorno do intervalo',
    'Saída',
  ];
  return types[index % types.length];
}
