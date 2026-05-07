import 'package:exemplo_shared_preferences/view/exemplo1_page.dart';
import 'package:exemplo_shared_preferences/view/exemplo2_page.dart';
import 'package:exemplo_shared_preferences/view/exemplo3_page.dart';
import 'package:exemplo_shared_preferences/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Criamos um notificador global para gerenciar o tema da aplicação
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  // Garante que os widgets do Flutter estejam inicializados antes de rodar código async
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Busca a preferência de tema salva antes de iniciar o app
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool('darkMode') ?? false;
  
  // Define o valor inicial do notificador baseado no que está salvo
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // O ValueListenableBuilder escuta as mudanças no themeNotifier
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          // Configurações de tema do MaterialApp
          theme: ThemeData.light(), // Tema claro padrão
          darkTheme: ThemeData.dark(), // Tema escuro padrão
          themeMode: currentMode, // O modo atual (Controlado pelo ValueNotifier)
          
          routes: {
            "/tela1": (context) => const Exemplo1Page(),
            "/tela2": (context) => const Exemplo2Page(),
            "/tela3": (context) => const Exemplo3Page()
          },
          home: const HomePage(),
        );
      },
    );
  }
}