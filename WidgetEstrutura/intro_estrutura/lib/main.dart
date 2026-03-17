//criar o void main responsável por rodar o elemento principal da aplicação

import 'package:flutter/material.dart';

void main() {
  //runApp => chama o elemento com o materialApp
  runApp(MainApp());
}

//criar a classe MainApp
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //construtor da tela estática
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Tela de Login"),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //elementos de input de texto
              Text("E-mail"),
              TextField(),
              Text("Senha"),
              TextField(textAlign: TextAlign.center,obscureText: true,),
              TextButton(onPressed: (){}, child: Text("Enviar"))
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: //Itens permite mais de 1 elemento, abrir colchetes
          [
            BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "back"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.arrow_forward), label: "forward"),
          ]
        ),
      ),
    );
  }
}
