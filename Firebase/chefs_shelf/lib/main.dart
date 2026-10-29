// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_screen.dart';
import 'core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChefsShelfApp());
}

class ChefsShelfApp extends StatelessWidget {
  const ChefsShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef\'s Shelf',
      theme: AppTheme.lightTheme,
      // StreamBuilder decide qual tela mostrar baseado no status de login
      home: StreamBuilder(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          // Se a conexão com o Firebase estiver carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          // Se snapshot.hasData for true, temos um usuário logado
          if (snapshot.hasData) {
            return const MainScreen();
          }
          // Caso contrário, mostra a tela de login
          return const AuthScreen();
        },
      ),
    );
  }
}