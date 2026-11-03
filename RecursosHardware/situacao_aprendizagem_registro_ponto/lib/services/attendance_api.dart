import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/api_exception.dart';
import '../models/attendance_record.dart';
import '../models/employee.dart';
import '../models/workplace.dart';

class AttendanceApi {
  AttendanceApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    final base = AppConfig.apiBaseUrl.replaceFirst(RegExp(r'/$'), '');
    return Uri.parse('$base/$path').replace(queryParameters: queryParameters);
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      return await _client.get(uri).timeout(AppConfig.requestTimeout);
    } on TimeoutException {
      throw const ApiException('A API demorou demais para responder.');
    } on http.ClientException {
      throw const ApiException(
        'Não foi possível conectar ao Json-Server. Confira a rede e o endereço da API.',
      );
    }
  }

  Future<Employee> signIn({
    required String identifier,
    required String password,
  }) async {
    final normalizedIdentifier = identifier.trim();
    final field = normalizedIdentifier.contains('@') ? 'email' : 'nif';
    final response = await _get(
      _uri('users', {field: normalizedIdentifier}),
    );
    final users = _decodeList(response, 'Não foi possível consultar os usuários.');

    for (final item in users) {
      if (item is Map<String, dynamic> &&
          item['password']?.toString() == password) {
        return Employee.fromJson(item);
      }
    }

    throw const ApiException('NIF/email ou senha inválidos.');
  }

  Future<Employee> findEmployeeById(String id) async {
    final response = await _get(_uri('users/${Uri.encodeComponent(id)}'));
    if (response.statusCode != 200) {
      throw const ApiException('Não foi possível localizar o usuário salvo.');
    }
    final decoded = _decodeObject(response, 'Resposta inválida ao consultar usuário.');
    return Employee.fromJson(decoded);
  }

  Future<Workplace> loadWorkplace() async {
    final response = await _get(_uri('workplaces'));
    final workplaces = _decodeList(
      response,
      'Não foi possível carregar o local de trabalho.',
    );
    if (workplaces.isEmpty || workplaces.first is! Map<String, dynamic>) {
      throw const ApiException(
        'Cadastre o local de trabalho na coleção workplaces do Json-Server.',
      );
    }
    return Workplace.fromJson(workplaces.first as Map<String, dynamic>);
  }

  Future<List<AttendanceRecord>> loadTodayRecords(String employeeId) async {
    final response = await _get(
      _uri('attendances', {'employeeId': employeeId}),
    );
    final records = _decodeList(response, 'Não foi possível carregar os pontos.');
    final today = DateTime.now();
    return records
        .whereType<Map<String, dynamic>>()
        .map(AttendanceRecord.fromJson)
        .where(
          (record) =>
              record.timestamp.year == today.year &&
              record.timestamp.month == today.month &&
              record.timestamp.day == today.day,
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<AttendanceRecord> createAttendance({
    required Employee employee,
    required String type,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required double distanceMeters,
  }) async {
    final body = jsonEncode({
      'employeeId': employee.id,
      'employeeName': employee.name,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'distanceMeters': distanceMeters,
    });

    late final http.Response response;
    try {
      response = await _client
          .post(
            _uri('attendances'),
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(AppConfig.requestTimeout);
    } on TimeoutException {
      throw const ApiException('A API demorou demais para salvar o registro.');
    } on http.ClientException {
      throw const ApiException('Não foi possível enviar o registro à API.');
    }

    if (response.statusCode != 201) {
      throw ApiException(
        'A API recusou o registro (HTTP ${response.statusCode}).',
      );
    }
    return AttendanceRecord.fromJson(
      _decodeObject(response, 'A API retornou uma resposta inválida ao salvar.'),
    );
  }

  List<dynamic> _decodeList(http.Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw ApiException('$errorMessage (HTTP ${response.statusCode}).');
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw ApiException('$errorMessage A resposta não contém JSON válido.');
    }
    if (decoded is! List<dynamic>) {
      throw ApiException('$errorMessage O formato recebido não é uma lista.');
    }
    return decoded;
  }

  Map<String, dynamic> _decodeObject(
    http.Response response,
    String errorMessage,
  ) {
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw ApiException('$errorMessage A resposta não contém JSON válido.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(errorMessage);
    }
    return decoded;
  }

  void close() => _client.close();
}
