import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/visitante_model.dart';
import '../theme/theme_manager.dart'; // Importe o ThemeManager
import 'cadastro_visitante_screen.dart';
import 'detalhe_visitante_screen.dart';

class HomeScreen extends StatefulWidget {
  final ThemeManager themeManager; // Recebe o gerenciador

  const HomeScreen({Key? key, required this.themeManager}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Visitante> _visitantes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _atualizarListaVisitantes();
  }

  Future<void> _atualizarListaVisitantes() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getVisitantes();
    setState(() {
      _visitantes = data;
      _isLoading = false;
    });
  }

  Future<void> _deletarVisitante(int id) async {
    await DatabaseHelper.instance.deleteVisitante(id);
    _atualizarListaVisitantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Acessos'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeManager.themeMode == ThemeMode.dark 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.themeManager.toggleTheme();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
          : _visitantes.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  itemCount: _visitantes.length,
                  itemBuilder: (context, index) {
                    final visitante = _visitantes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              visitante.nome[0].toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20, fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(visitante.nome, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Doc: ${visitante.documento}\n${visitante.tipo} | Nasc: ${visitante.dataNascimento}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)), // Cor On-Error
                          onPressed: () => _deletarVisitante(visitante.id!),
                        ),
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => DetalheVisitanteScreen(visitante: visitante)));
                          _atualizarListaVisitantes();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary, // Call to Action Laranja
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Novo Registro', style: Theme.of(context).textTheme.labelLarge),
        onPressed: () async {
          final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroVisitanteScreen()));
          if (resultado == true) _atualizarListaVisitantes();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 80, color: Theme.of(context).colorScheme.surfaceVariant),
          const SizedBox(height: 24),
          Text('Nenhum registro encontrado', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Toque no botão abaixo para adicionar.', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}