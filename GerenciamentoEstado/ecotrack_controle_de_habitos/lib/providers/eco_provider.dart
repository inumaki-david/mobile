import 'package:flutter/material.dart';
import '/models/habito.dart';

// A classe usa 'with ChangeNotifier' para ganhar a habilidade de avisar o app sobre mudanças
class EcoProvider with ChangeNotifier {
  // Lista principal que armazena todos os hábitos
  List<Habito> _habitos = [
    Habito(id: '1', titulo: 'Separar lixo reciclável'),
    Habito(id: '2', titulo: 'Economizar água no banho'),
    Habito(id: '3', titulo: 'Usar garrafa reutilizável'),
  ];

  // Controla qual aba do BottomNavigationBar está ativa (0: Dashboard, 1: Hábitos, 2: Config).
  int _indiceNavegacaoAtual = 1; 

  // Controla se o Modo Escuro está ligado ou desligado.
  bool _isDarkMode = false;

  // Getters - Permitem que as telas leiam as informações sem o risco de corromper os dados originais
  List<Habito> get habitos => _habitos;
  List<Habito> get habitosPendentes => _habitos.where((h) => !h.isConcluido).toList(); // Filtra a lista principal para retornar apenas os hábitos que NÃO estão concluídos
  List<Habito> get habitosConcluidos => _habitos.where((h) => h.isConcluido).toList(); // Filtra a lista principal para retornar apenas os hábitos concluídos
  int get indiceNavegacaoAtual => _indiceNavegacaoAtual;
  
  bool get isDarkMode => _isDarkMode;

  // Cálculos do Dashboard
  int get totalConcluidos => habitosConcluidos.length;
  int get totalPendentes => habitosPendentes.length;
  int get pontuacaoVerde => totalConcluidos * 20; // Cada hábito concluído vale 20 pontos de "Pontuação Verde"
  // Calcula a percentagem da meta semanal concluída.
  double get metaSemanal {
    if (_habitos.isEmpty) return 0.0;
    return (totalConcluidos / _habitos.length) * 100;
  }

  // MÉTODOS DE AÇÃO 
  // Adiciona um novo hábito à lista com um ID único baseado no tempo
  void adicionarHabito(String titulo) {
    final novoHabito = Habito(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
    );
    _habitos.add(novoHabito);
    notifyListeners(); // Avisa as telas para mostrarem o novo hábito
  }

  // Encontra um hábito pelo ID e inverte o seu estado (de pendente para concluído e vice-versa)
  void alternarStatusHabito(String id) {
    final indice = _habitos.indexWhere((h) => h.id == id);
    if (indice != -1) {
      _habitos[indice].isConcluido = !_habitos[indice].isConcluido;
      notifyListeners(); // Atualiza as listas e o dashboard simultaneamente
    }
  }

  // Remove um hábito permanentemente.
  void removerHabito(String id) {
    _habitos.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  // Atualiza qual ecrã está a ser visualizado no menu principal
  void setIndiceNavegacao(int indice) {
    _indiceNavegacaoAtual = indice;
    notifyListeners();
  }

  // Desmarca todos os hábitos, resetando o progresso mas mantendo a lista
  void redefinirProgresso() {
    for (var habito in _habitos) {
      habito.isConcluido = false;
    }
    notifyListeners();
  }

  // Altera o estado do Modo Escuro
  void alternarTema(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
  
  // Garante que, ao sair do app e voltar, o utilizador comece pelo Dashboard
  void resetarNavegacaoParaInicio() {
    _indiceNavegacaoAtual = 0;
    notifyListeners();
  }
}