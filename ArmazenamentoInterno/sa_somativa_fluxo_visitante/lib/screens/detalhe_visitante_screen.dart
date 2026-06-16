import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/visitante_model.dart';
import '../models/visita_model.dart';

class DetalheVisitanteScreen extends StatefulWidget {
  final Visitante visitante;
  const DetalheVisitanteScreen({Key? key, required this.visitante}) : super(key: key);

  @override
  State<DetalheVisitanteScreen> createState() => _DetalheVisitanteScreenState();
}

class _DetalheVisitanteScreenState extends State<DetalheVisitanteScreen> {
  List<Visita> _visitas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarVisitas();
  }

  Future<void> _carregarVisitas() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getVisitasPorVisitante(widget.visitante.id!);
    setState(() {
      _visitas = data;
      _isLoading = false;
    });
  }

  void _mostrarModalNovaVisita() {
    final motivoController = TextEditingController();
    final unidadeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color, // Level 2 Surface
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 32, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Registrar Entrada', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              TextField(
                controller: unidadeController,
                decoration: const InputDecoration(labelText: 'Unidade (Ex: Apto 42)', prefixIcon: Icon(Icons.door_front_door)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: motivoController,
                decoration: const InputDecoration(labelText: 'Motivo da Entrada', prefixIcon: Icon(Icons.assignment)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary), // Laranja
                  onPressed: () async {
                    if (motivoController.text.isNotEmpty && unidadeController.text.isNotEmpty) {
                      final novaVisita = Visita(
                        visitanteId: widget.visitante.id!, dataEntrada: DateTime.now().toString(),
                        motivo: motivoController.text, unidadeDestino: unidadeController.text,
                      );
                      await DatabaseHelper.instance.insertVisita(novaVisita);
                      Navigator.pop(context);
                      _carregarVisitas();
                    }
                  },
                  child: const Text('Liberar Acesso'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _formatarData(String dataIso) {
    final data = DateTime.parse(dataIso);
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface; // Fallback seguro

    return Scaffold(
      appBar: AppBar(title: const Text('Ficha do Visitante')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor, // Usando a variável segura
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: colorScheme.primary.withOpacity(0.2),
                  child: Text(widget.visitante.nome[0].toUpperCase(), 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.visitante.nome, style: textTheme.headlineMedium?.copyWith(fontSize: 22)),
                      const SizedBox(height: 4),
                      Text('CPF: ${widget.visitante.documento}', style: textTheme.bodyMedium),
                      Text('${widget.visitante.tipo} | Nasc: ${widget.visitante.dataNascimento}', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Histórico de Visitas', style: Theme.of(context).textTheme.titleLarge)),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _visitas.isEmpty
                    ? Center(child: Text('Nenhuma visita registrada.', style: Theme.of(context).textTheme.bodyMedium))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _visitas.length,
                        itemBuilder: (context, index) {
                          final visita = _visitas[index];
                          final emAndamento = visita.dataSaida == null;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text('Unidade: ${visita.unidadeDestino}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                                      ),
                                      // Pill Indicator
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: emAndamento ? Theme.of(context).colorScheme.secondary.withOpacity(0.2) : const Color(0xFF1E2020),
                                          borderRadius: BorderRadius.circular(9999), // Stadium Pill
                                          border: Border.all(color: emAndamento ? Theme.of(context).colorScheme.secondary : const Color(0xFF414753)),
                                        ),
                                        child: Text(
                                          emAndamento ? 'Em Andamento' : 'Concluída',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: emAndamento ? Theme.of(context).colorScheme.secondary : const Color(0xFFC1C6D5)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Motivo: ${visita.motivo}', style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(Icons.login, size: 16, color: Color(0xFFAAC7FF)),
                                      const SizedBox(width: 8),
                                      Text('Início: ${_formatarData(visita.dataEntrada)}', style: Theme.of(context).textTheme.bodyMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.logout, size: 16, color: emAndamento ? Colors.grey[700] : const Color(0xFF8B919F)),
                                      const SizedBox(width: 8),
                                      Text(
                                        emAndamento ? 'Fim: Pendente' : 'Fim: ${_formatarData(visita.dataSaida!)}',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: emAndamento ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.onSurface),
                                      ),
                                    ],
                                  ),
                                  if (emAndamento) ...[
                                    const Divider(height: 32, color: Color(0xFF414753)),
                                    SizedBox(
                                      width: double.infinity, height: 40,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          foregroundColor: Theme.of(context).colorScheme.secondary,
                                        ),
                                        onPressed: () async {
                                          await DatabaseHelper.instance.registrarSaida(visita.id!, DateTime.now().toString());
                                          _carregarVisitas();
                                        },
                                        child: const Text('Registrar Saída'),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _mostrarModalNovaVisita,
      ),
    );
  }
}