import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //verificará o estado da autenticação e redirecionar para tarefas se ja estiver logado ou login se não estiver logado
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TarefaScreen();
        }
        return LoginScreen();
      },
    );
  }
}
