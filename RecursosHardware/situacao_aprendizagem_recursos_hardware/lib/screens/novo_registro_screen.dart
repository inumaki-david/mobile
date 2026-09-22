import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _estaObtendoGps = false;
  bool _estaSalvando = false;

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  // Solicita permissão e abre a câmera ou galeria do dispositivo, salvando de forma permanente.
  Future<void> _capturarFoto({ImageSource source = ImageSource.camera}) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    }

    if (status.isPermanentlyDenied) {
      _mostrarDialogoConfiguracoes(
        'Permissão Necessária',
        'O acesso à câmera/armazenamento foi desabilitado permanentemente. Por favor, habilite nas configurações do aparelho.',
      );
      return;
    }

    if (status.isGranted || status.isLimited) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? foto = await picker.pickImage(
          source: source,
          imageQuality: 85,
        );

        if (foto != null) {
          // Salva a imagem no diretório permanente do aplicativo (Etapa 4)
          final appDir = await getApplicationDocumentsDirectory();
          final imagensDir = Directory('${appDir.path}/imagens');
          if (!await imagensDir.exists()) {
            await imagensDir.create(recursive: true);
          }

          final String novoCaminho =
              '${imagensDir.path}/registro_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final File fotoPermanente = await File(foto.path).copy(novoCaminho);

          setState(() => _caminhoFoto = fotoPermanente.path);
        }
      } catch (e) {
        _mostrarMensagem('Erro ao capturar imagem: $e');
      }
    } else {
      _mostrarMensagem('Permissão para uso da câmera foi negada!');
    }
  }

  // Modal para escolha entre Câmera ou Galeria
  void _abrirModalOrigemFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF004F9F)),
              title: const Text('Câmera do Dispositivo'),
              onTap: () {
                Navigator.of(ctx).pop();
                _capturarFoto(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF004F9F)),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.of(ctx).pop();
                _capturarFoto(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Solicita permissão e captura as coordenadas de GPS com tratamento de serviço e fallback.
  Future<void> _obterLocalizacao() async {
    setState(() => _estaObtendoGps = true);

    try {
      // 1. Verifica se o serviço de GPS do aparelho está ativo
      bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        _mostrarDialogoGpsDesativado();
        setState(() => _estaObtendoGps = false);
        return;
      }

      // 2. Verifica e solicita permissões de localização
      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          _mostrarMensagem('Permissão de localização negada!');
          setState(() => _estaObtendoGps = false);
          return;
        }
      }

      if (permissao == LocationPermission.deniedForever) {
        _mostrarDialogoConfiguracoes(
          'Localização Necessária',
          'A permissão de localização foi negada permanentemente. Por favor, habilite nas configurações para capturar as coordenadas do ponto.',
        );
        setState(() => _estaObtendoGps = false);
        return;
      }

      // 3. Obtém a posição atual com timeout e fallback (Etapa 3)
      Position? posicaoAtual;
      try {
        posicaoAtual = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (_) {
        // Fallback para a última localização conhecida em caso de timeout
        posicaoAtual = await Geolocator.getLastKnownPosition();
      }

      if (posicaoAtual != null) {
        setState(() => _posicao = posicaoAtual);
        _mostrarMensagem('Coordenadas GPS obtidas com sucesso!');
      } else {
        _mostrarMensagem('Não foi possível obter sinal de GPS no momento.');
      }
    } catch (e) {
      _mostrarMensagem('Erro ao obter localização: $e');
    } finally {
      if (mounted) {
        setState(() => _estaObtendoGps = false);
      }
    }
  }

  // Reúne os dados, salva no SQLite local e emite feedback visual e sonoro.
  Future<void> _salvarRegistro() async {
    if (_caminhoFoto == null) {
      _mostrarMensagem('Capture a foto do local/atividade antes de salvar.');
      return;
    }

    if (_posicao == null) {
      _mostrarMensagem('Obtenha a localização GPS antes de salvar.');
      return;
    }

    setState(() => _estaSalvando = true);

    try {
      final novoRegistro = Registro(
        dataHora: DateTime.now().toIso8601String(),
        latitude: _posicao!.latitude,
        longitude: _posicao!.longitude,
        observacao: _observacaoController.text.trim(),
        caminhoFoto: _caminhoFoto!,
      );

      await DatabaseHelper().inserirRegistro(novoRegistro);

      // Feedback sonoro (Etapa 7)
      try {
        await FlutterRingtonePlayer().playNotification();
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Registro de ponto salvo com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // Retorna para a tela de lista com flag de sucesso
      }
    } catch (e) {
      _mostrarMensagem('Erro ao salvar no banco de dados: $e');
    } finally {
      if (mounted) {
        setState(() => _estaSalvando = false);
      }
    }
  }

  void _mostrarMensagem(String texto) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texto), behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _mostrarDialogoGpsDesativado() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('GPS Desativado'),
          ],
        ),
        content: const Text(
          'O serviço de localização (GPS) do aparelho está desligado. Por favor, ative-o para registrar a localização.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Geolocator.openLocationSettings();
            },
            child: const Text('Ativar GPS'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoConfiguracoes(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Ponto / Diário de Campo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seção de Foto com visualização e botão de captura
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: _caminhoFoto == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, size: 56, color: Colors.grey.shade500),
                              const SizedBox(height: 8),
                              Text(
                                'Nenhuma foto capturada',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ],
                          )
                        : Image.file(
                            File(_caminhoFoto!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _abrirModalOrigemFoto,
                            icon: Icon(
                              _caminhoFoto == null ? Icons.camera_alt : Icons.replay,
                              color: const Color(0xFF004F9F),
                            ),
                            label: Text(
                              _caminhoFoto == null ? 'Capturar Foto' : 'Trocar Foto',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Seção de Localização GPS
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: _posicao != null ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Localização GPS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (_posicao != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check, size: 14, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  'Fixado',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 20),
                    if (_posicao != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Latitude', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(
                                _posicao!.latitude.toStringAsFixed(6),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Longitude', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(
                                _posicao!.longitude.toStringAsFixed(6),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Precisão: ±${_posicao!.accuracy.toStringAsFixed(1)}m',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      const Text(
                        'Clique no botão abaixo para capturar as coordenadas geográficas exatas do local da visita.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: _estaObtendoGps
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Obtendo sinal do GPS...'),
                                  ],
                                ),
                              ),
                            )
                          : FilledButton.tonalIcon(
                              onPressed: _obterLocalizacao,
                              icon: const Icon(Icons.gps_fixed),
                              label: Text(
                                _posicao == null ? 'Obter Localização Exata' : 'Atualizar Localização',
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Seção de Observação / Descrição
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.edit_note, color: Color(0xFF004F9F)),
                        SizedBox(width: 8),
                        Text(
                          'Observações da Visita / Ponto',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _observacaoController,
                      decoration: const InputDecoration(
                        hintText: 'Descreva a atividade realizada, inspeção ou motivo do registro...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botão Principal de Finalização
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF004F9F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _estaSalvando ? null : _salvarRegistro,
                icon: _estaSalvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _estaSalvando ? 'Salvando Registro...' : 'Finalizar Registro',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}