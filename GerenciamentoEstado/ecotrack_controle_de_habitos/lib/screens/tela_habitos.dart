import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/eco_provider.dart';
import '/widgets/eco_card.dart';

class TelaHabitos extends StatelessWidget {
  const TelaHabitos({Key? key}) : super(key: key);

  // Esta função abre uma "janela" que desliza de baixo para cima.
  void _abrirModalAdicionarHabito(BuildContext context) {
    final TextEditingController _controller = TextEditingController(); // O controller captura o que o utilizador digita no campo de texto.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que o modal suba quando o teclado aparece
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20, left: 20, right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adicionar Novo Hábito', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Campo de introdução de texto
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Digite o nome da ação...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCELAR', style: TextStyle(color: Colors.green)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    // Verifica se o campo não está vazio antes de adicionar
                    if (_controller.text.isNotEmpty) {
                      // context.read envia o comando para o Provider
                      context.read<EcoProvider>().adicionarHabito(_controller.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('ADICIONAR', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // O DefaultTabController coordena a sincronização entre a barra de abas e o conteúdo.
    return DefaultTabController(
      length: 2, // Duas abas: Pendentes e Concluídos
      child: Column(
        children: [
          // Barra de Abas superior
          const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'PENDENTES'),
              Tab(text: 'CONCLUÍDOS'),
            ],
          ),
          // Expanded garante que a lista ocupe todo o espaço disponível na tela.
          Expanded(
            child: Consumer<EcoProvider>(
              // O Consumer "escuta" o EcoProvider e reconstrói a lista quando há mudanças.
              builder: (context, provider, child) {
                return TabBarView(
                  children: [
                    // Aba 1: Lista de Hábitos Pendentes
                    ListView.builder(
                      itemCount: provider.habitosPendentes.length,
                      itemBuilder: (context, index) {
                        return EcoCard(habito: provider.habitosPendentes[index]);
                      },
                    ),
                    // Aba 2: Lista de Hábitos Concluídos
                    ListView.builder(
                      itemCount: provider.habitosConcluidos.length,
                      itemBuilder: (context, index) {
                        return EcoCard(habito: provider.habitosConcluidos[index]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          // Botão flutuante para adicionar 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () => _abrirModalAdicionarHabito(context),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}