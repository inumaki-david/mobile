class Pet {
    //atributos
    int ? id; //pode ser nulo inicialmente => quem irá atribuir o ID é o BD
    String nome;
    String raca;
    String nomeDono;
    String telefone;

    // atribuir público, se fossem privados, precisaria dos getters and setters (metódos públicos) => encapsulamento

    //construtor 
    Pet({this.id, required this.nome, required this.raca, required this.nomeDono, required this.telefone});

    //mapeamento de dados
    //toMap
    Map<String,dynamic> toMap() => {
        "id": id,
        "nome": nome,
        "raca": raca,
        "nomeDono": nomeDono,
        "telefone": telefone
    };
    //fromMap
    factory Pet.fromMap(Map<String,dynamic> map) => Pet(
        id: map["id"],
        nome: map["nome"],
        raca: map["raca"],
        nomeDono: map["nomeDono"],
        telefone: map["telefone"]
    );
}