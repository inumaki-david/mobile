import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/registro_model.dart';
import 'novo_registro_screen.dart';
import 'detalhes_registro_screen.dart';

// Tela inicial que exibe a listagem do diário de campo e recupera dados do SQLite.
class ListaRegistrosScreen extends StatefulWidget {
  const ListaRegistrosScreen({super.key});

  @override
  State<ListaRegistrosScreen> createState() => _ListaRegistrosScreenState();
}

class _ListaRegistrosScreenState extends State<ListaRegistrosScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Registro> _registros = [];
  bool _estaCarregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  // Solicita ao DatabaseHelper a lista atualizada e atualiza a interface.
  Future<void> _carregarRegistros() async {
    setState(() => _estaCarregando = true);
    final registros = await dbHelper.listarRegistros();
    if (mounted) {
      setState(() {
        _registros = registros;
        _estaCarregando = false;
      });
    }
  }

  // Navega para a tela de detalhes do item
  Future<void> _abrirDetalhes(Registro registro) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesRegistroScreen(registro: registro),
      ),
    );

    // Se houve exclusão ou alteração, recarrega a lista
    if (resultado == true) {
      _carregarRegistros();
    }
  }

  // Navega para a tela de novo cadastro
  Future<void> _abrirNovoRegistro() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const NovoRegistroScreen()),
    );

    if (resultado == true) {
      _carregarRegistros();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SENAI Check-In',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Diário de Campo & Ponto Eletrônico',
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar lista',
            onPressed: _carregarRegistros,
          ),
        ],
      ),
      body: _estaCarregando
          ? const Center(child: CircularProgressIndicator())
          : _registros.isEmpty
              ? _buildEstadoVazio()
              : RefreshIndicator(
                  onRefresh: _carregarRegistros,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: _registros.length,
                    itemBuilder: (context, index) {
                      final registro = _registros[index];
                      final fileExists = File(registro.caminhoFoto).existsSync();

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _abrirDetalhes(registro),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Miniatura da foto
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade200,
                                    child: fileExists
                                        ? Image.file(
                                            File(registro.caminhoFoto),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Informações do registro
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 13,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            registro.dataHoraFormatada,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        registro.observacao.trim().isEmpty
                                            ? 'Visita sem observação'
                                            : registro.observacao,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: registro.observacao.trim().isEmpty
                                              ? Colors.grey.shade600
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      // Chip com coordenadas GPS
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 12,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${registro.latitude.toStringAsFixed(4)}, ${registro.longitude.toStringAsFixed(4)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF004F9F),
        foregroundColor: Colors.white,
        onPressed: _abrirNovoRegistro,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Novo Ponto'),
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF004F9F).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_searching,
                size: 64,
                color: Color(0xFF004F9F),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nenhum registro encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toque no botão abaixo para registrar um novo ponto de visita com foto e localização GPS.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF004F9F),
              ),
              onPressed: _abrirNovoRegistro,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Criar Primeiro Registro'),
            ),
          ],
        ),
      ),
    );
  }
}
