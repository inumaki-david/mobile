//página de exibição das notas

import 'package:exemplo_sqflite/nota_dbhelper.dart';
import 'package:exemplo_sqflite/nota_model.dart';
import 'package:flutter/material.dart';

class NotaPage extends StatefulWidget {
  const NotaPage({super.key});

  @override
  State<NotaPage> createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  //instaciar DBHelper
  final NotaDbhelper _dbhelper = NotaDbhelper();
  //toda vez que precisar de conexão com o banco, usar o dbhelper

  //atributos
  List<Nota> _notas = [];
  bool _isLoading = true; //usar como indicador de conexão com o DB

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  //carregar as notas para o vetor
  void _carregarNotas() async {
    setState(() {
      _isLoading = true;
    });
    //chama o método read do crud
    _notas = [];
    _notas = await _dbhelper.getNotas(); //carregar as notas para a lista
    setState(() {
      _isLoading = false;
    });
  }

  //criar nota no DB
  void _addNota() async {
    Nota novaNota = Nota(
      titulo: "Nota ${DateTime.now()}",
      conteudo: "Conteúdo da Nota",
    );
    _dbhelper.create(novaNota);
    _carregarNotas();
  }

  //deletar nota no DB
  void _deleteNota(int id) async {
    _dbhelper.deleteNota(id);
    _carregarNotas();
  }

  //uptade nota no DB
  void _updateNota(Nota nota) async {
    Nota notaAtualizada = Nota(
      id: nota.id,
      titulo: "${nota.titulo} (editado)",
      conteudo: nota.conteudo,
    );
    //criar um alertDialog para atualizar a nota
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Atualizar Nota"),
          content: TextField(
            controller: TextEditingController(text: nota.conteudo),
            onChanged: (value) {
              notaAtualizada = Nota(
                id: nota.id,
                titulo: nota.titulo,
                conteudo: value,
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _dbhelper.updateNota(notaAtualizada);
                _carregarNotas();
              },
              child: Text("Atualizar"),
            ),
          ],
        );
      },
    );
  }

  //criar o build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minha Notas"),),
      body: _isLoading
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: _notas.length,
        itemBuilder: (context,index) {
          final nota = _notas[index];
          return ListTile(
            title: Text(nota.titulo),
            subtitle: Text(nota.conteudo),
            trailing: IconButton(
              onPressed: () => _deleteNota(nota.id!), 
              icon: Icon(Icons.delete, color: Colors.red,)
            ),
            onLongPress: () => _updateNota(nota),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNota,
        tooltip: "Adicionar Nota",
        child: Icon(Icons.add, color: Colors.green,),
      ),
    );
  }
}
