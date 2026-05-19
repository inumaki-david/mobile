//Modelagem de Dados

class Nota {
  //atributos
  final int? id; //permite que a variável seja nula
  //no primeiro momento a variável é nula, somente quando cair no DB, irá receber um ID
  final String titulo;
  final String conteudo;

  //construtor
  Nota({this.id, required this.titulo, required this.conteudo});

  //método de serialização de dados (toMap() fromMap())

  //toMap() => Converter um obj da Classe Nota para MAP de DB (insere os dados no DB)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "conteudo": conteudo,
    }; //mapeando as colunas do DB com os atributos da classe
  }

  //fromMap() => Converter um Map para um obj da Classe Nota
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map["id"] as int, //se está voltando do DB, já possui um ID
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String,
    );
  }

  //método para imprimir os dados
  @override
  String toString() {
    return "Nota{id: $id, titulo: $titulo, conteudo: $conteudo}";
  }
}
