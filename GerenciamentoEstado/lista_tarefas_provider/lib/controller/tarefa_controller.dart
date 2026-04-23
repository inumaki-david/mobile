import 'package:flutter/material.dart';
import 'package:lista_tarefas_provider/model/tarefa.dart';

class TarefaController extends ChangeNotifier {
  //ChangeNotifier -> Classe do Provider
  //Tarefas Controller está herdando elementos da ChangeNotifier
  //Herda o método notifierListener()

  //atributos
  //lista para armazenar as tarefas criadas
  List<Tarefa> _tarefas = []; //atributo privado

  //getter
  List<Tarefa> get tarefas => _tarefas;
  //método get para acessar os dados da lista privada

  //Método Crud
  //adicionar tarefa (create)
  void criarTarefa(String titulo) {
    //verificar se o texto não é vazio
    if (titulo.trim().isEmpty) return; //interrompe o método

    _tarefas.add(Tarefa(titulo: titulo.trim()));

    //avisa os listeners
    //atualiza os widgets que usar este dado
    notifyListeners();
  }

  //alterar tarefa (update)
  void alterarTarefa(int index) {
    //inverter o valor da booleana "!"
    _tarefas[index].concluida = !_tarefas[index].concluida;
    notifyListeners();
  }

  //remover tarefa (delete)
  void removerTarefa(int index) {
    //void => função que não tem retorno
    //busca a tarefa e remove da lista
    _tarefas.removeAt(index);
    notifyListeners();
  }

  //criar métricas para usar no DashboardPage
  //calcular o total de tarefas
  //calcular quantas tarefas tem no vetor
  int get totalTarefas => _tarefas.length;

  //total de tarefas concluídas
  int get totalTarefasConcluidas =>
      _tarefas.where((tarefa) => tarefa.concluida).length;

  //total de tarefas pendentes
  int get totalTarefasPendentes =>
      _tarefas.where((tarefa) => !tarefa.concluida).length;

  //porcentagem de tarefas concluídas
  double get porcentagemTarefasConcluidas {
    if (_tarefas.isEmpty) return 0;
    return (totalTarefasConcluidas / totalTarefas) * 100;
  }

}
