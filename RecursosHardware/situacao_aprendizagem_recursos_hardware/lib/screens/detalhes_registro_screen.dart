import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database_helper.dart';
import '../models/registro_model.dart';

// Tela de detalhes do registro, com exibição de foto ampliada, coordenadas, mapa e opção de exclusão.
class DetalhesRegistroScreen extends StatelessWidget {
  final Registro registro;

  const DetalhesRegistroScreen({super.key, required this.registro});

  // Abre a localização no aplicativo de mapas (Google Maps ou navegador)
  Future<void> _abrirMapa(BuildContext context) async {
    final lat = registro.latitude;
    final lng = registro.longitude;
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não foi possível abrir o aplicativo de mapas.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao abrir mapa: $e')),
        );
      }
    }
  }

  // Exibe diálogo de confirmação antes de excluir
  Future<void> _confirmarExclusao(BuildContext context) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Excluir Registro'),
          ],
        ),
        content: const Text('Tem certeza que deseja excluir este registro de ponto/campo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true && registro.id != null) {
      await DatabaseHelper().excluirRegistro(registro.id!);
      
      // Se houver arquivo de foto, podemos tentar remover para liberar espaço
      try {
        final arquivo = File(registro.caminhoFoto);
        if (await arquivo.exists()) {
          await arquivo.delete();
        }
      } catch (_) {}

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro excluído com sucesso!'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop(true); // Retorna indicando que foi excluído
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final existeFoto = File(registro.caminhoFoto).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Registro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir registro',
            onPressed: () => _confirmarExclusao(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem ampliada do registro
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.black12,
              child: existeFoto
                  ? Image.file(
                      File(registro.caminhoFoto),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Arquivo de foto não encontrado', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card de Data e Hora
                  Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.access_time_filled, color: theme.colorScheme.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Data e Hora do Registro',
                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  registro.dataHoraFormatada,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Card de Localização GPS
                  Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.location_on, color: Colors.green),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  'Coordenadas de GPS',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Latitude', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(
                                    registro.latitude.toStringAsFixed(6),
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Longitude', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(
                                    registro.longitude.toStringAsFixed(6),
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _abrirMapa(context),
                              icon: const Icon(Icons.map_outlined),
                              label: const Text('Abrir no Google Maps'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Card de Observações
                  Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.notes, color: Colors.orange),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Observações / Relato',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            registro.observacao.trim().isEmpty
                                ? 'Nenhuma observação informada.'
                                : registro.observacao,
                            style: TextStyle(
                              fontSize: 14,
                              color: registro.observacao.trim().isEmpty ? Colors.grey : Colors.black87,
                              fontStyle: registro.observacao.trim().isEmpty ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
