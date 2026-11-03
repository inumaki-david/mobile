// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Escuta as mudanças de estado (se o usuário está logado ou não)
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Função para Login
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Retorna nulo se houver sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro do Firebase
    }
  }

  // Função para Cadastro
  Future<String?> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Função para Sair
  Future<void> signOut() async {
    await _auth.signOut();
  }
}