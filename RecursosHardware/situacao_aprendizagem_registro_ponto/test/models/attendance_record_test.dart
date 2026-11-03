import 'package:situacao_aprendizagem_registro_ponto/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:situacao_aprendizagem_registro_ponto/models/attendance_record.dart';
import 'package:situacao_aprendizagem_registro_ponto/models/api_exception.dart';
import 'package:situacao_aprendizagem_registro_ponto/models/workplace.dart';

void main() {
  test('uses the API host for the current platform when not overridden', () {
    expect(
      AppConfig.apiBaseUrl,
      kIsWeb || defaultTargetPlatform != TargetPlatform.android
          ? 'http://localhost:3000'
          : 'http://10.0.2.2:3000',
    );
  });

  group('attendance radius', () {
    test(
      'allows the exact 100 meter boundary and rejects anything beyond it',
      () {
        expect(AppConfig.isWithinAttendanceRadius(100), isTrue);
        expect(AppConfig.isWithinAttendanceRadius(100.01), isFalse);
      },
    );
  });

  group('attendanceTypeForIndex', () {
    test('cycles through the four workday punches', () {
      expect(attendanceTypeForIndex(0), 'Entrada');
      expect(attendanceTypeForIndex(1), 'Início do intervalo');
      expect(attendanceTypeForIndex(2), 'Retorno do intervalo');
      expect(attendanceTypeForIndex(3), 'Saída');
      expect(attendanceTypeForIndex(4), 'Entrada');
    });
  });

  group('Workplace.fromJson', () {
    test('parses valid coordinates', () {
      final workplace = Workplace.fromJson({
        'name': 'Escritório',
        'latitude': -23.5,
        'longitude': -46.6,
      });

      expect(workplace.name, 'Escritório');
      expect(workplace.latitude, -23.5);
      expect(workplace.longitude, -46.6);
    });

    test('rejects coordinates outside valid ranges', () {
      expect(
        () => Workplace.fromJson({'latitude': 91, 'longitude': -46.6}),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
