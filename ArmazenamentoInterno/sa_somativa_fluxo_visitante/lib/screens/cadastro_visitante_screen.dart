import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/visitante_model.dart';

class CadastroVisitanteScreen extends StatefulWidget {
  const CadastroVisitanteScreen({Key? key}) : super(key: key);

  @override
  State<CadastroVisitanteScreen> createState() => _CadastroVisitanteScreenState();
}

class _CadastroVisitanteScreenState extends State<CadastroVisitanteScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar o texto dos inputs
  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _idadeController = TextEditingController();
  final _enderecoController = TextEditingController();

  Future<void> _salvarVisitante() async {
    // Valida se todos os campos preenchem os requisitos
    if (_formKey.currentState!.validate()) {
      final novoVisitante = Visitante(
        nome: _nomeController.text,
        documento: _documentoController.text,
        idade: int.parse(_idadeController.text),
        endereco: _enderecoController.text,
      );

      // Insere no banco de dados
      final resultado = await DatabaseHelper.instance.insertVisitante(novoVisitante);

      if (!mounted) return; // Garante que o widget ainda está na tela antes de mostrar o SnackBar

      if (resultado != -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visitante cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Volta para a tela anterior passando 'true' para atualizar a lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar. Verifique se o documento já existe.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _documentoController.dispose();
    _idadeController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Visitante'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView( // Permite rolagem caso o teclado cubra a tela
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentoController,
                decoration: const InputDecoration(
                  labelText: 'Documento (RG/CPF)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obrigatório';
                  final idade = int.tryParse(value);
                  if (idade == null || idade <= 0 || idade >= 120) {
                    return 'Insira uma idade válida'; // Regra de Negócio RN-001
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _salvarVisitante,
                child: const Text(
                  'Salvar Registro',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}