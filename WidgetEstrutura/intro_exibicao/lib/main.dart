//tela para estudo dos widgets de exibição
//tex, image, icon entre outros

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      //configurações iniciais do app
      //router => rotas de navegação
      //home => página inicial
      //theme app => claro/escuro
      home: MyApp(),
    ),
  ); //gosto de colocar o MaterialApp no void main
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //estrutura da tela 
  @override
  Widget build(BuildContext context) {
    return Scaffold( //elemento principal de tela
      //appbar, drawer, bnbar, body, fabutton, snakebar
      appBar: AppBar(title: Text("Exemplos de Widget de Exibição"),),
      body: SingleChildScrollView( //adicionando um scroll para a tela //+ usado para scroll de Tela Inteira
        child: Padding(
          padding: EdgeInsets.all(16),
          //Widget de Text
          //adicionar um container
          child: Expanded( //+ usado para Scroll de Parte da Tela
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Explorando o Flutter!", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),),
                //dentro da column
                //adicionar uma image
                Image.network(
                  //link da imagem
                  "https://images.unsplash.com/photo-1665077713402-ad959854d778",
                  height: 400,
                  fit: BoxFit.contain,),
                Image.asset("assets/img/patoassassino.jpg",
                  height: 250,
                  fit: BoxFit.cover,),
              ],
            ),
          ), 
          ),
      ),
    );
  }
}
