// lib/view/ponto_view.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_view.dart';

class PontoView extends StatefulWidget {
  const PontoView({super.key});

  @override
  State<PontoView> createState() => _PontoViewState();
}

class _PontoViewState extends State<PontoView> {
  // Coordenadas fixas do SENAI Americana (Regra de negócio)
  final double _senaiLat = -22.7639306;
  final double _senaiLon = -47.3429840;

  // Variáveis para controlar a interface (estado)
  bool _verificandoLocal = false;
  bool _podeBaterPonto = false;
  String _mensagemStatus = 'Clique no botão para verificar a tua localização.';
  Position? _posicaoAtual;

  // Método educativo: Função assíncrona para lidar com o hardware de GPS
  Future<void> _verificarLocalizacao() async {
    setState(() => _verificandoLocal = true);

    try {
      // 1. Verifica se o GPS do telemóvel está fisicamente ligado
      bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) throw Exception('Por favor, liga o GPS do dispositivo.');

      // 2. Verifica as permissões de privacidade do utilizador
      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          throw Exception('Permissão de localização recusada.');
        }
      }
      if (permissao == LocationPermission.deniedForever) {
        throw Exception('Permissões recusadas permanentemente nas definições.');
      }

      // 3. Obtém a posição atual com alta precisão
      _posicaoAtual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Calcula a distância matemática em metros
      double distancia = Geolocator.distanceBetween(
        _posicaoAtual!.latitude,
        _posicaoAtual!.longitude,
        _senaiLat,
        _senaiLon,
      );

      // 5. Aplica a regra de negócio e atualiza a interface visual
      setState(() {
        _podeBaterPonto = distancia <= 100;
        
        if (_podeBaterPonto) {
          _mensagemStatus = 'Está na área da empresa (${distancia.toStringAsFixed(0)}m). Pode registar o ponto!';
        } else {
          _mensagemStatus = 'Está muito longe (${distancia.toStringAsFixed(0)}m). Aproxime-se para bater o ponto.';
        }
      });

    } catch (e) {
      setState(() {
        _mensagemStatus = 'Erro: $e';
        _podeBaterPonto = false;
      });
    } finally {
      setState(() => _verificandoLocal = false);
    }
  }

  // Método provisório: Na próxima fase vamos ligar isto à base de dados
  void _registrarPonto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ponto registado (Simulação - A aguardar Fase 4)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Termina a sessão no Firebase e regressa ao Login
  Future<void> _sair() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registar Ponto'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _sair,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              _podeBaterPonto ? Icons.location_on : Icons.location_off,
              size: 80,
              color: _podeBaterPonto ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 24),
            
            Text(
              _mensagemStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            _verificandoLocal
                ? const Center(child: CircularProgressIndicator())
                : OutlinedButton.icon(
                    onPressed: _verificarLocalizacao,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Verificar Localização'),
                  ),
            
            const SizedBox(height: 16),

            if (!_verificandoLocal)
              ElevatedButton(
                onPressed: _podeBaterPonto ? _registrarPonto : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('BATER PONTO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
