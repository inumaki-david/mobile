import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const RegistroPontoApp());
}

class RegistroPontoApp extends StatelessWidget {
  const RegistroPontoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF15233F);
    const teal = Color(0xFF168B83);

    return MaterialApp(
      title: 'Ponto Certo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          primary: teal,
          secondary: const Color(0xFFF0A44B),
          surface: const Color(0xFFF7F8FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FA),
          foregroundColor: ink,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E9EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: teal, width: 1.5),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
