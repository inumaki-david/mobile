import 'package:exemplo_shared_preferences/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo2Page extends StatefulWidget {
  const Exemplo2Page({super.key});

  @override
  State<Exemplo2Page> createState() => _Exemplo2PageState();
}

class _Exemplo2PageState extends State<Exemplo2Page> {
  late SharedPreferences
  _prefs; // escopo late, permite  criar uma variável/obj inicialmente nula e mudar o valor depois, pode ser mudada quantas vezes for necessário
  bool _darkMode = false;

  // método de conexão com o SharedPreferences
  @override
  void initState() {
    // rodo: implement initState
    super.initState();
    _loadPreferences();
  }

  // método para buscar dados no Shared
  void _loadPreferences() async {
    _prefs =
        await SharedPreferences.getInstance(); // pega as informações salvas no Shared
    setState(() {
      _darkMode =
          _prefs.getBool("darkMode") ??
          false; // verificação de nulidade obrigatória, ?? se caso a chave darkMode do Shared seja nula (não tenha atribuído ainda) a variável _darkMode será false
    });
  }

  // método para salvar dados no Shared
  void savePreferences() async {
    setState(() {
      _darkMode = !_darkMode; // inverte o valor da booleana
    });
    await _prefs.setBool("darkMode", _darkMode); // atribuindo o valor da variável _darkMode a chave darkMode do Shared
    themeNotifier.value = _darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modo Escuro com Shared Preferences"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tema Atual: ${_darkMode ? "Escuro" : "Claro"}"),
            Switch(value: _darkMode, onChanged: (_) => savePreferences()),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}
