import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/visitante_model.dart';
import 'cadastro_visitante_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Visitante> _visitantes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _atualizarListaVisitantes();
  }

  // Busca os dados no SQLite e atualiza o estado da tela
  Future<void> _atualizarListaVisitantes() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getVisitantes();
    setState(() {
      _visitantes = data;
      _isLoading = false;
    });
  }

  // Deleta um visitante e atualiza a lista
  Future<void> _deletarVisitante(int id) async {
    await DatabaseHelper.instance.deleteVisitante(id);
    _atualizarListaVisitantes();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitante removido com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Visitantes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _visitantes.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum visitante cadastrado.\nToque no botão + para adicionar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _visitantes.length,
                  itemBuilder: (context, index) {
                    final visitante = _visitantes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            visitante.nome[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          visitante.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Doc: ${visitante.documento}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deletarVisitante(visitante.id!),
                        ),
                        onTap: () {
                          // TODO: Navegar para a tela de Detalhes e Histórico de Visitas
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Aguarda o retorno da tela de cadastro. Se for 'true', atualiza a lista.
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroVisitanteScreen()),
          );
          if (resultado == true) {
            _atualizarListaVisitantes();
          }
        },
      ),
    );
  }
}