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
  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _enderecoController = TextEditingController();
  
  String _tipoSelecionado = 'Visitante';
  final List<String> _tipos = ['Visitante', 'Prestador de Serviço'];

  Future<void> _selecionarData() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (dataEscolhida != null) {
      setState(() {
        _dataNascController.text = "${dataEscolhida.day.toString().padLeft(2, '0')}/${dataEscolhida.month.toString().padLeft(2, '0')}/${dataEscolhida.year}";
      });
    }
  }

  Future<void> _salvarVisitante() async {
    if (_formKey.currentState!.validate()) {
      final novoVisitante = Visitante(
        nome: _nomeController.text,
        documento: _documentoController.text,
        dataNascimento: _dataNascController.text,
        endereco: _enderecoController.text,
        tipo: _tipoSelecionado,
      );
      final resultado = await DatabaseHelper.instance.insertVisitante(novoVisitante);
      if (!mounted) return;
      if (resultado != -1) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Este CPF já está cadastrado!'), backgroundColor: Color(0xFF93000A)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cadastro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0), // Margin Desktop do DS
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                decoration: const InputDecoration(labelText: 'Tipo de Registro', prefixIcon: Icon(Icons.category)),
                items: _tipos.map((String tipo) => DropdownMenuItem<String>(value: tipo, child: Text(tipo))).toList(),
                onChanged: (String? newValue) => setState(() { _tipoSelecionado = newValue!; }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo', prefixIcon: Icon(Icons.person)),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CPF / Documento', prefixIcon: Icon(Icons.badge)),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataNascController,
                readOnly: true,
                onTap: _selecionarData,
                decoration: const InputDecoration(labelText: 'Data de Nascimento', prefixIcon: Icon(Icons.calendar_today)),
                validator: (value) => value!.isEmpty ? 'Selecione uma data' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço (Cidade/Bairro)', prefixIcon: Icon(Icons.map)),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarVisitante,
                  child: const Text('Confirmar e Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}