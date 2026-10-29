// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isLogin = true; // Controla se estamos na tela de login ou cadastro
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    String? erro;
    if (_isLogin) {
      erro = await _authService.signIn(email: email, password: password);
    } else {
      erro = await _authService.signUp(email: email, password: password);
    }

    setState(() => _isLoading = false);

    // Se a tela ainda estiver montada e houver erro, exibe o erro
    if (erro != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                _isLogin ? 'Bem-vindo de volta!' : 'Crie sua conta',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      child: Text(_isLogin ? 'Entrar' : 'Cadastrar'),
                    ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Ainda não tem conta? Cadastre-se' : 'Já tem conta? Faça Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}