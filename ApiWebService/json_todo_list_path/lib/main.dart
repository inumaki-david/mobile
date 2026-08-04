import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildUbuntuDarkTheme(), 
      home: const ListaTarefasPage(),
    ),
  );
}

// Configuração do Design System: Ubuntu Dynamic Dark
ThemeData _buildUbuntuDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121414), 
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1275E2), 
      secondary: Color(0xFFF65C0E), 
      surface: Color(0xFF1E2020),
      onSurface: Color(0xFFE2E2E2),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E2020),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFE2E2E2)),
    ),
    // CORREÇÃO: Utilizando CardThemeData para compatibilidade com versões recentes do Flutter
    cardTheme: CardThemeData(
      color: const Color(0xFF333333), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFF65C0E),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))), 
    ),
    // CORREÇÃO: Utilizando DialogThemeData 
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF333333),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E2020),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1275E2)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1275E2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({super.key});

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  List<Map<String, dynamic>> tarefas = [];
  final TextEditingController _controleTarefa = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lerTarefas().then((lista) {
      setState(() {
        tarefas = lista;
      });
    });
  }

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    final caminho = '${diretorio.path}/tarefas.json';
    return File(caminho);
  }

  Future<void> _salvarTarefas() async {
    final arquivo = await _getArquivo();
    String jsonTarefas = json.encode(tarefas);
    await arquivo.writeAsString(jsonTarefas);
  }

  Future<List<Map<String, dynamic>>> _lerTarefas() async {
    try {
      final arquivo = await _getArquivo();
      String conteudo = await arquivo.readAsString();
      List<dynamic> dados = json.decode(conteudo);
      return dados.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  void _adicionarTarefa() {
    if (_controleTarefa.text.isNotEmpty) {
      setState(() {
        Map<String, dynamic> novaTarefa = {
          "titulo": _controleTarefa.text,
          "concluida": false,
        };
        tarefas.add(novaTarefa);
      });
      _controleTarefa.clear();
      _salvarTarefas();
      Navigator.pop(context);
    }
  }

  void _remover(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
    _salvarTarefas();
  }

  void _alterarStatus(int index, bool? valor) {
    setState(() {
      tarefas[index]["concluida"] = valor;
    });
    _salvarTarefas();
  }

  void _mostrarDialogoAdicionar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nova Tarefa"),
          content: TextField(
            controller: _controleTarefa,
            decoration: const InputDecoration(hintText: "Digite a tarefa"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFD9D9D9)),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: _adicionarTarefa,
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Tarefas")),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                tarefas[index]["titulo"],
                style: const TextStyle(fontSize: 16),
              ),
              leading: Checkbox(
                value: tarefas[index]["concluida"],
                activeColor: const Color(0xFFF65C0E), 
                onChanged: (valor) => _alterarStatus(index, valor),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFFD9D9D9)),
                onPressed: () => _remover(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}