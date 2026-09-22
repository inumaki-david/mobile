import 'package:flutter/material.dart';
import 'screens/lista_registros_screen.dart';

void main() {
  // Garante que os recursos nativos e canais de plataforma estejam prontos antes de desenhar a interface
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const SenaiCheckinApp());
}

// Classe raiz da aplicação que define as configurações de tema e navegação primária.
class SenaiCheckinApp extends StatelessWidget {
  const SenaiCheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF004F9F); // Azul institucional SENAI
    const secondaryColor = Color(0xFFE30613); // Vermelho institucional SENAI (para destaques e alertas)

    return MaterialApp(
      title: 'SENAI Check-In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Colors.grey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 2,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
      home: const ListaRegistrosScreen(),
    );
  }
}