import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_exception.dart';
import '../models/employee.dart';
import '../services/attendance_api.dart';
import 'attendance_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = AttendanceApi();
  final _auth = LocalAuthentication();
  bool _isLoading = false;
  bool _hidePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _api.close();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final employee = await _api.signIn(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('lastEmployeeId', employee.id);
      if (mounted) _openAttendance(employee);
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Não foi possível preparar o acesso: ${error.message}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final preferences = await SharedPreferences.getInstance();
      final employeeId = preferences.getString('lastEmployeeId');
      if (employeeId == null) {
        setState(() {
          _errorMessage =
              'Entre com NIF/email e senha uma vez antes de usar a biometria.';
        });
        return;
      }

      if (!await _auth.isDeviceSupported()) {
        setState(() {
          _errorMessage = 'Este aparelho não oferece autenticação biométrica.';
        });
        return;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: 'Confirme sua identidade para acessar o Ponto Certo',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (!authenticated) return;

      final employee = await _api.findEmployeeById(employeeId);
      if (mounted) _openAttendance(employee);
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'A biometria não pôde ser concluída: ${error.message}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openAttendance(Employee employee) {
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => AttendanceScreen(
          employee: employee,
          onSignOut: () {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              (_) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 76,
                      height: 76,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F3F1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.access_time_filled_rounded,
                        color: Color(0xFF168B83),
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Ponto Certo',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF15233F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seu dia começa com um registro simples e seguro.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF667085),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _identifierController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'NIF ou e-mail',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Informe seu NIF ou e-mail.'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _signIn(),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              tooltip: _hidePassword ? 'Mostrar senha' : 'Ocultar senha',
                              onPressed: () =>
                                  setState(() => _hidePassword = !_hidePassword),
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Informe sua senha.'
                              : null,
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          _ErrorBanner(message: _errorMessage!),
                        ],
                        const SizedBox(height: 22),
                        FilledButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Entrar'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _signInWithBiometrics,
                          icon: const Icon(Icons.fingerprint_rounded),
                          label: const Text('Entrar com biometria'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: Color(0xFF667085)),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'O ponto só pode ser registrado perto do trabalho.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF667085), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFB42318)),
      ),
    );
  }
}
