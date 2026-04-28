import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/eco_provider.dart';
import 'tela_inicial.dart'; // Importa a tela inicial para poder voltar para ela

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escutam o provider para ler os dados atuais 
    final provider = context.watch<EcoProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          title: Text('Preferências Visuais', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),

        // O SwitchListTile é um widget pronto que combina um texto com um botão de ligar/desligar
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
          title: const Text('Modo Escuro'),
          subtitle: const Text('Alterar tema de todo o aplicativo'),
          value: provider.isDarkMode, // O valor atual vem do Provider
          onChanged: (bool valor) {
            // Quando o usuário clica, envia o novo valor para o Provider
            context.read<EcoProvider>().alternarTema(valor);
          },
        ),

        const Divider(), // Uma linha horizontal para organizar a tela

        // Secção de Dados
        const ListTile(
          title: Text('Gerenciamento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        
        ListTile(
          leading: const Icon(Icons.refresh, color: Colors.orange),
          title: const Text('Redefinir Progresso'),
          subtitle: const Text('Desmarca todos os hábitos concluídos.'),
          onTap: () {
            // Executa a lógica de reset no Provider
            context.read<EcoProvider>().redefinirProgresso();
            // Exibe um feedback visual rápido (uma barra no rodapé) para confirmar a ação
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Progresso redefinido!')),
            );
          },
        ),

        const Divider(),

        // Este item simula um "Logout" ou retorno ao início.
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
          title: const Text('Sair para a Tela Inicial', style: TextStyle(color: Colors.redAccent)),
          subtitle: const Text('Voltar à tela de apresentação do app.'),
          onTap: () {
            // Boa prática: Reseta a aba de navegação antes de sair
            context.read<EcoProvider>().resetarNavegacaoParaInicio();
            
            // Navega para a Tela Inicial e remove todas as telas anteriores da memória
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TelaInicial()),
              (route) => false, // O "false" significa "destrua todas as rotas anteriores"
            );
          },
        ),
      ],
    );
  }
}