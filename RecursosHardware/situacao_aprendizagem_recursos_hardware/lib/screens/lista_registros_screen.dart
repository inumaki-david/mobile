import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/registro_model.dart';
import 'novo_registro_screen.dart';

// Tela inicial que exibe a listagem do diário de campo e recupera dados do SQLite.
class ListaRegistrosScreen extends StatefulWidget {
  const ListaRegistrosScreen({super.key});

  @override
  State<ListaRegistrosScreen> createState() => _ListaRegistrosScreenState();
}

class _ListaRegistrosScreenState extends State<ListaRegistrosScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Registro> _registros = [];

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  // Solicita ao DatabaseHelper a lista atualizada e refaz a tela (setState).
  void _carregarRegistros() async {
    final registros = await dbHelper.listarRegistros();
    setState(() => _registros = registros);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diário de Campo - SENAI')),
      body: _registros.isEmpty
          ? const Center(child: Text('Nenhum registro encontrado. Crie um novo!'))
          : ListView.builder(
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final registro = _registros[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.file(
                      File(registro.caminhoFoto),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(registro.observacao.isEmpty ? 'Sem observação' : registro.observacao),
                    subtitle: Text('${registro.dataHora}\nLat: ${registro.latitude.toStringAsFixed(4)}, Lng: ${registro.longitude.toStringAsFixed(4)}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NovoRegistroScreen()),
          );
          _carregarRegistros(); // Atualiza a lista ao voltar da tela de cadastro
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}