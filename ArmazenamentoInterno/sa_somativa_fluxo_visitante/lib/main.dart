import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Garante que os bindings do Flutter estão inicializados antes de chamadas assíncronas (como o SQLite)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Visitantes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Mantendo a estabilidade visual dos componentes clássicos
      ),
      home: const HomeScreen(),
    );
  }
}