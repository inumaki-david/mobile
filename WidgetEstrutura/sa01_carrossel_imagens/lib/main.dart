//Situação de Aprendizagem 01 - Carrossel de Imagens no Flutter (Stateless)
//usar uma lista de imagens para montar um carrossel no flutter
//flutter pub add carousel_slider (Biblioteca do Flutter Pub Get)

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // remover a flag do debug
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //remover o const
  //para usar a lista de imagens
  MyApp({super.key});

  //Lista de Imagens(Array)
  List<String> imagens = [
    "https://i.pinimg.com/1200x/53/bd/70/53bd70c05d8ba6b337052d6e3ee88679.jpg",
    "https://i.pinimg.com/1200x/4a/62/96/4a62961e8327727e510e635bbda2c715.jpg",
    "https://i.pinimg.com/736x/12/2f/bb/122fbb9f3f7185a79517f5f1850968e4.jpg",
    "https://i.pinimg.com/1200x/df/67/8c/df678cd8fa6b2db63e8e07751dff321c.jpg",
    "https://i.pinimg.com/736x/70/f0/02/70f00202ba9509a89f13b06a6af7d142.jpg",
    "https://i.pinimg.com/1200x/3e/d4/9a/3ed49ad7f9dc49aaf2ed29ea82e15861.jpg",
    "https://i.pinimg.com/736x/9a/8a/d2/9a8ad2be7c43255a622849228b4f1d6a.jpg",
    "https://i.pinimg.com/736x/ac/59/1e/ac591e9945c70b3a9f8f143f9b84f2e4.jpg",
    "https://i.pinimg.com/1200x/3c/0f/67/3c0f67343aa7770a1fb1a947b45fa54f.jpg",
    "https://i.pinimg.com/736x/89/87/87/898787e056fd90bb3cb52bd1aa8aba0e.jpg",
  ];


  //build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria de Imagens"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
          //carrosel de imagens da galeria
          CarouselSlider(
            options: CarouselOptions(
              height: 300, //altura máxima do carrossel
              autoPlay: true //pre-definição de scroll do carrossel
            ),
            items: imagens.map(
              ((url)=>Container(
                margin: EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(url, fit: BoxFit.cover, width: 1000,),
                ),
              ))
            ).toList()
          ),
          //Galeria de Imagens
          Expanded(
            child: GridView.builder(
              //como vou montar o grid (Layout do Grid)
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //número de colunas
                crossAxisSpacing:8, //espaçamento entre colunas
                mainAxisSpacing: 8 //espaçamento entre linhas
                ), 
              itemCount: imagens.length, // quantidade de elementos da lista é a quantidade de elementos do grid
              //construtor do grid
              //construindo usando um foreach
              itemBuilder: (context,index)=> //arrow function
                GestureDetector(
                  onTap: () => _mostrarImagem(context,index), //método para mostrar a imagem no detalhe
                  child: ClipRRect(borderRadius: BorderRadius.circular(8), //arredodar os cantos da imagem
                  child: Image.network(imagens[index],fit: BoxFit.cover,),), 
                )
              )
          )
          ],
        ),
      ),
    );
  }

  void _mostrarImagem(BuildContext context, int index) {
    //imagen => endereço URL da Imagem
    //mpostrar imagens com mais detalhe ao ser clicada, 
    //precisa do index da imagem para buscar no array
    //showDialog => Mostrar a imagem
    showDialog(
      context: context, // contexto da tela 
      builder: (context)=>Dialog(
        child: Image.network(imagens[index]),
      ));
  }
}