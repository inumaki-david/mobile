// Arquivo principal da aplicação

//sempre começa com um void main

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
      home: //
      Scaffold(
        appBar: AppBar(title: Text("App do Davi")),
        body: Center(
          child: ElevatedButton(
            onPressed: (){
              Fluttertoast.showToast(
                msg: "Olá Galera",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,);
            },
            child: Text("Botão"),
          ),
        ),
      ),
  ));
}
