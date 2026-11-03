import 'api_exception.dart';

class Workplace {
  const Workplace({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  factory Workplace.fromJson(Map<String, dynamic> json) {
    final latitude = (json['latitude'] as num?)?.toDouble();
    final longitude = (json['longitude'] as num?)?.toDouble();
    if (latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      throw const ApiException('O local de trabalho tem coordenadas inválidas.');
    }

    return Workplace(
      name: json['name']?.toString() ?? 'Local de trabalho',
      latitude: latitude,
      longitude: longitude,
    );
  }
}
