import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/eco_provider.dart';

class TelaDashboard extends StatelessWidget {
  const TelaDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EcoProvider>();
    // O context.watch faz com que esta tela se redesenhe sempre que o EcoProvider disparar um 'notifyListeners()'

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seu Progresso de Impacto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // O Expanded permite que o GridView ocupe o espaço restante da tela
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Define 2 colunas
              crossAxisSpacing: 16, // Espaço horizontal entre cards
              mainAxisSpacing: 16,// Espaço vertical entre cards
              children: [ 
                _buildCard(
                  context,
                  titulo: 'Hábitos Concluídos',
                  valor: '${provider.totalConcluidos}',
                  icone: Icons.emoji_events,
                ),
                _buildCard(
                  context,
                  titulo: 'Hábitos Pendentes',
                  valor: '${provider.totalPendentes}',
                  icone: Icons.schedule,
                ),
                _buildCard(
                  context,
                  titulo: 'Pontuação Verde',
                  valor: '${provider.pontuacaoVerde} pts',
                  icone: Icons.eco,
                ),
                _buildCard(
                  context,
                  titulo: 'Meta Semanal',
                  valor: '${provider.metaSemanal.toStringAsFixed(0)}%',
                  icone: Icons.pie_chart,
                ),
              ],
            ),
          ),
          const Center(
            child: Text('Continue assim!\nVeja seu impacto no mundo!', textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Essa função cria o design de um card uma única vez e apenas preenchemos com os dados.
  Widget _buildCard(BuildContext context, {required String titulo, required String valor, required IconData icone}) {
    final corPrimaria = Theme.of(context).colorScheme.primary;
    final corFundo = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: corFundo, // Fica branco no tema claro, e cinza escuro no tema escuro
        borderRadius: BorderRadius.circular(16),
        // Adiciona uma borda sutil com a cor verde primária
        border: Border.all(color: corPrimaria.withOpacity(0.3), width: 2), 
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, size: 40, color: corPrimaria),
          const SizedBox(height: 10),
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 5),
          // Valor numérico vindo do Provider
          Text(valor, style: TextStyle(fontSize: 18, color: corPrimaria, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}