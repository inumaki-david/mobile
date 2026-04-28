import 'package:flutter/material.dart';
import 'tela_principal.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final corTextoBase = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'EcoTrack',
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold, 
                  // Puxa a cor primária (verde) definida no tema global
                  color: Theme.of(context).colorScheme.primary
                ),
              ),
              const SizedBox(height: 40), // SizedBox cria um espaço vazio entre os elementos (espaçamento)
              
              Icon(
                Icons.public, 
                size: 150, 
                color: Theme.of(context).colorScheme.primary
              ),
              const SizedBox(height: 40),


              Text(
                'Seu parceiro ecológico!',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: corTextoBase // Adapta-se ao modo claro/escuro
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              Text(
                'O EcoTrack foi criado para ajudar você a monitorar, gamificar e melhorar seus hábitos sustentáveis. Registre suas ações diárias, como economia de água e reciclagem, e acompanhe seu impacto positivo no nosso planeta.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  color: corTextoBase.withOpacity(0.7), // Adapta e fica suave
                  height: 1.5 // Define o espaçamento entre linhas (interlineado)
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                // Puxa as cores de fundo e texto configuradas no tema para botões
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Cor do texto do botão
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  // pushReplacement substitui a Tela Inicial pela Tela Principal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaPrincipal()),
                  );
                },
                child: const Text('COMEÇAR JORNADA', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}