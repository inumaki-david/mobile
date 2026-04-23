// Modelagem de Dados

import 'package:flutter/material.dart';

class Tarefa {
  //atributos
  String titulo; //armazena o título da tarefa
  bool concluida; //status da tarefa
  DateTime dataCriacao; //classse que armazena informações da data

  // //construtor padrão
  // Tarefa(String titulo) {
  //   this.titulo = titulo;
  //   this.concluida = false;
  //   this.dataCriacao = DateTime.now();
  // }

  //construtor resumido
  Tarefa ({
    required this.titulo,
    this.concluida = false,
    DateTime? dataCriacao
  }) : dataCriacao = dataCriacao ?? DateTime.now(); //se data de criação for nulo, atribui uma data DateTime.now() -> pega a data atual

  //classe de modelagem de dados, toda tarefa criada é um obj da classe Tarefa. Toda tarefa tem um título, um status de conclusão e uma data de criação
  
}
