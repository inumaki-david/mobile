import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../database/database_helper.dart';
import '../models/registro_model.dart';

// Tela responsável pela interface de captura de foto, coordenadas e persistência.
class NovoRegistroScreen extends StatefulWidget {
  const NovoRegistroScreen({super.key});

  @override
  State<NovoRegistroScreen> createState() => _NovoRegistroScreenState();
}

class _NovoRegistroScreenState extends State<NovoRegistroScreen> {
  final _observacaoController = TextEditingController();
  String? _caminhoFoto;
  Position? _posicao;
  bool _estaCarregando = false;

  // Solicita permissão e abre a câmera do dispositivo.
  Future<void> _tirarFoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? foto = await picker.pickImage(source: ImageSource.camera);
      if (foto != null) {
        setState(() => _caminhoFoto = foto.path);
      }
    } else {
      _mostrarMensagem('Permissão de câmera negada!');
    }
  }

  // Solicita permissão e captura as coordenadas de GPS.
  Future<void> _obterLocalizacao() async {
    setState(() => _estaCarregando = true);
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      try {
        Position posicaoAtual = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() => _posicao = posicaoAtual);
      } catch (e) {
        _mostrarMensagem('Erro ao obter localização: $e');
      }
    } else {
      _mostrarMensagem('Permissão de localização negada!');
    }
    setState(() => _estaCarregando = false);
  }

  // Reúne os dados, salva no SQLite local e emite feedback visual e sonoro.
  Future<void> _salvarRegistro() async {
    if (_caminhoFoto == null || _posicao == null) {
      _mostrarMensagem('Tire a foto e obtenha a localização primeiro.');
      return;
    }

    final novoRegistro = Registro(
      dataHora: DateTime.now().toString(),
      latitude: _posicao!.latitude,
      longitude: _posicao!.longitude,
      observacao: _observacaoController.text,
      caminhoFoto: _caminhoFoto!,
    );

    await DatabaseHelper().inserirRegistro(novoRegistro);
    FlutterRingtonePlayer().playNotification(); // Confirmação sonora
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro salvo!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Retorna para a tela de lista
    }
  }

  void _mostrarMensagem(String texto) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Ponto / Checkin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: _caminhoFoto == null
                  ? const Center(child: Text('Nenhuma foto capturada'))
                  : Image.file(File(_caminhoFoto!), fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _tirarFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Tirar Foto do Local'),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Latitude: ${_posicao?.latitude ?? '---'}'),
                    Text('Longitude: ${_posicao?.longitude ?? '---'}'),
                    const SizedBox(height: 10),
                    _estaCarregando 
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: _obterLocalizacao,
                            icon: const Icon(Icons.gps_fixed),
                            label: const Text('Obter Localização Exata'),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observações sobre a visita (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: _salvarRegistro,
              icon: const Icon(Icons.save),
              label: const Text('Finalizar Registro'),
            ),
          ],
        ),
      ),
    );
  }
}