import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/eco_provider.dart';
import 'screens/tela_inicial.dart';

void main() {
  runApp(
    // Envolvendo o app no MultiProvider para injeção de dependência
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EcoProvider()),
      ],
      child: const EcoTrackApp(),
    ),
  );
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escutamos o Provider para saber se o usuário ativou o modo escuro
    final provider = context.watch<EcoProvider>();

    return MaterialApp(
      title: 'EcoTrack',
      debugShowCheckedModeBanner: false,
      
      // paleta de cores para o tema claro
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFF7EBC89), // Verde suave moderno
          primary: const Color(0xFF2D6A4F), // Verde escuro para botões e ícones
          secondary: const Color(0xFF7EBC89), 
          tertiary: const Color(0xFFC1DBB3), // Verde pastel muito claro
          surface: Colors.white, // Fundo dos cards
          background: const Color(0xFFF4F9F4), // Fundo da tela (levemente esverdeado)
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC1DBB3), 
          foregroundColor: Color(0xFF1B4332), // Texto escuro no topo
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2D6A4F), // Item ativo escuro e sólido
          unselectedItemColor: Colors.black54,
        ),
      ),

      // paleta de cores para o tema escuro
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF7EBC89),
          primary: const Color(0xFF7EBC89), // No escuro, o verde claro ganha o destaque
          secondary: const Color(0xFFC1DBB3),
          surface: const Color(0xFF1B221E), // Fundo dos cards (cinza com toque de verde)
          background: const Color(0xFF111512), // Fundo da tela super escuro e minimalista
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111512),
          foregroundColor: Color(0xFF7EBC89),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // Destacamos o item ativo apenas pela cor mais brilhante, sem efeitos extras
          selectedItemColor: Color(0xFF7EBC89), 
          unselectedItemColor: Colors.white38,
        ),
      ),

      // O Flutter usa o tema correto baseado na nossa variável
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const TelaInicial(),
    );
  }
}