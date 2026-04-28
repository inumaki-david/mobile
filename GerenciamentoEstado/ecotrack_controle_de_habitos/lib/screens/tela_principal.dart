import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/eco_provider.dart';
import 'tela_dashboard.dart';
import 'tela_habitos.dart';
import 'tela_configuracoes.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  // Lista de telas constante que guarda os widgets das páginas
  final List<Widget> _telas = const [
    TelaDashboard(),
    TelaHabitos(),
    TelaConfiguracoes(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EcoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoTrack'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Fundo Verde
              ),
              child: const Text(
                'Menu EcoTrack', 
                style: TextStyle(color: Colors.white, fontSize: 24), // Texto sempre branco para contrastar
              ),
            ),
            // Itens do Menu: Cada ListTile chama o Provider para mudar o índice.
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                context.read<EcoProvider>().setIndiceNavegacao(0);
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Hábitos'),
              onTap: () {
                context.read<EcoProvider>().setIndiceNavegacao(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                context.read<EcoProvider>().setIndiceNavegacao(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _telas[provider.indiceNavegacaoAtual], 
      // Barra de navegação
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.indiceNavegacaoAtual,
        // Quando o usuário toca num ícone, esta função envia o novo índice para o Provider.
        onTap: (index) => context.read<EcoProvider>().setIndiceNavegacao(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Hábitos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config.'),
        ],
      ),
    );
  }
}