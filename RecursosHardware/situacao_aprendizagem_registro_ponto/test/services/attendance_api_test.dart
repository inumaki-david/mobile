import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:situacao_aprendizagem_registro_ponto/models/api_exception.dart';
import 'package:situacao_aprendizagem_registro_ponto/models/employee.dart';
import 'package:situacao_aprendizagem_registro_ponto/services/attendance_api.dart';

void main() {
  group('AttendanceApi.signIn', () {
    test('looks up an employee by NIF and validates the password', () async {
      final api = AttendanceApi(
        client: MockClient((request) async {
          expect(request.url.path, '/users');
          expect(request.url.queryParameters, {'nif': '123456789'});
          return http.Response(
            jsonEncode([
              {
                'id': '1',
                'name': 'Davi Martins',
                'email': 'davi@example.com',
                'nif': '123456789',
                'password': 'ponto123',
              },
            ]),
            200,
          );
        }),
      );
      addTearDown(api.close);

      final employee = await api.signIn(
        identifier: '123456789',
        password: 'ponto123',
      );

      expect(employee.id, '1');
      expect(employee.name, 'Davi Martins');
    });

    test('rejects credentials that do not match a user', () async {
      final api = AttendanceApi(
        client: MockClient((_) async => http.Response('[]', 200)),
      );
      addTearDown(api.close);

      await expectLater(
        api.signIn(identifier: 'unknown@example.com', password: 'wrong'),
        throwsA(isA<ApiException>()),
      );
    });
  });

  test('createAttendance posts the time and device coordinates', () async {
    final timestamp = DateTime.utc(2026, 11, 3, 12, 0);
    final api = AttendanceApi(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/attendances');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['employeeId'], '1');
        expect(body['type'], 'Entrada');
        expect(body['timestamp'], timestamp.toIso8601String());
        expect(body['latitude'], -23.5);
        expect(body['longitude'], -46.6);
        expect(body['distanceMeters'], 42.0);
        return http.Response(jsonEncode({...body, 'id': 'record-1'}), 201);
      }),
    );
    addTearDown(api.close);

    final record = await api.createAttendance(
      employee: const Employee(
        id: '1',
        name: 'Davi Martins',
        email: 'davi@example.com',
        nif: '123456789',
      ),
      type: 'Entrada',
      timestamp: timestamp,
      latitude: -23.5,
      longitude: -46.6,
      distanceMeters: 42,
    );

    expect(record.id, 'record-1');
    expect(record.employeeId, '1');
    expect(record.distanceMeters, 42);
  });
}
