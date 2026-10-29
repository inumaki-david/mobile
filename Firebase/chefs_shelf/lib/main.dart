import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

void main() async {
  // Garante que os bindings do Flutter estão prontos antes de chamar código nativo
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase com as opções geradas para a plataforma atual
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),

      
      home: const Scaffold(
        body: Center(
          child: Text('Firebase Configurado com Sucesso! 🍳'),
        ),
      ),
    );
  }
}