import 'package:flutter/material.dart';
import 'screens/lista_registros_screen.dart'; // Importa a tela inicial modularizada

void main() {
  // Garante que os recursos nativos do celular estejam prontos antes de desenhar a interface
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const SenaiCheckinApp());
}

// Classe raiz da aplicação que define as configurações de tema e navegação primária.
class SenaiCheckinApp extends StatelessWidget {
  const SenaiCheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAI Checkin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ListaRegistrosScreen(), // Aponta para a nossa primeira tela
    );
  }
}