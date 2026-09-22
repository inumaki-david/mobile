import 'package:flutter_test/flutter_test.dart';
import 'package:situacao_aprendizagem_recursos_hardware/models/registro_model.dart';

void main() {
  group('Registro Model Tests', () {
    test('Deve converter Registro para Map e de Map para Registro corretamente', () {
      final registroOriginal = Registro(
        id: 1,
        dataHora: '2026-09-22T08:00:00.000',
        latitude: -23.55052,
        longitude: -46.633308,
        observacao: 'Visita técnica de inspeção',
        caminhoFoto: '/caminho/para/foto.jpg',
      );

      final map = registroOriginal.toMap();

      expect(map['id'], 1);
      expect(map['data_hora'], '2026-09-22T08:00:00.000');
      expect(map['latitude'], -23.55052);
      expect(map['longitude'], -46.633308);
      expect(map['observacao'], 'Visita técnica de inspeção');
      expect(map['caminho_da_foto'], '/caminho/para/foto.jpg');

      final registroRecriado = Registro.fromMap(map);

      expect(registroRecriado.id, registroOriginal.id);
      expect(registroRecriado.dataHora, registroOriginal.dataHora);
      expect(registroRecriado.latitude, registroOriginal.latitude);
      expect(registroRecriado.longitude, registroOriginal.longitude);
      expect(registroRecriado.observacao, registroOriginal.observacao);
      expect(registroRecriado.caminhoFoto, registroOriginal.caminhoFoto);
    });

    test('Deve formatar data e hora corretamente', () {
      final registro = Registro(
        id: 2,
        dataHora: '2026-09-22T08:30:00.000',
        latitude: 0.0,
        longitude: 0.0,
        observacao: '',
        caminhoFoto: '',
      );

      expect(registro.dataHoraFormatada, '22/09/2026 08:30:00');
      expect(registro.dataCurta, '22/09/2026');
      expect(registro.horarioFormatado, '08:30');
    });
  });
}
