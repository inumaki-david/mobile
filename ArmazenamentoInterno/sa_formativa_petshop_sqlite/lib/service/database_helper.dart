class DatabaseHelper {
    //classe do tipo singleton (permite o instanciamento de um único obj por ver)
    static final DatabaseHelper _instance = DatabaseHelper._internal();

    //essa classe não possui um construtor normal
    //ele precisa do Factory para estabelecer a conexão com o banco de dados
    DatabaseHelper._internal();
    factory DatabaseHelper() => _instance;

    //com essa técnica de escrita de construtor, a classe permite a criação de apenas um obj por vez

    //conector do Banco de Dados
    Database ? _database; //privado

    //mpetodo get da conexão
    Future<Database> get database async {
        if (_database != null) return _database!; //se a conexão já existir, retorna a conexão existente 
        _database = await _initDb(); //se não existir conexão, cria uma nova
        return _database!;
    }
    
    Future<Database> _initDb() async {
        //começar a conexão com o banco
        String path = join (await getDatabasePath(), "petshop_db");
        return await openDatabase(
            path,
            version: 1,
            //a prinmeira vez que rodar o banco, cria as tabelas
            onCreate: (db, version) async {
                await db.execute(
                    '''CREATE TABLE pets(
                    id INTEGER PRIMARY KEY AUTOINCREMENT, 
                    nome TEXT, raca TEXT, 
                    nomeDono TEXT, 
                    telefone TEXT)'''
                );
                await db.execute(
                    '''CREATE TABLE consultas(
                    id INTEGER PRIMARY KEY AUTOINCREMENT, 
                    petId INTEGER, 
                    tipoServico TEXT, 
                    dataHora TEXT, 
                    observacoes TEXT,
                    FOREIGN KEY(petId) REFERENCES pets(id) ON DELETE CASCADE)'''
                );           
            },
            onConfigure: (db) async => await db.execute("PRAGMA foreing_key = ON"), //garante o delete on CASCADE
        );
    }

    //métodos do CRUD simplicados 

    //inserir pet
    Future<int> insertPet(Pet pet) async => (await database).insert("pets", pet.toMap());

    //listar pet do db
    Future<List<Pet>> getPets() async {
        //busca os pets no banco e retorna uma lista em ordem alfabética
        final List<Map<String, dynamic>> maps = await (await database).query("pets", orderBy: "nome ASC");
        return List.generate(maps.length, (e) => Pet.fromMap(maps[e]));
    }

    // inserir Consulta
    Future<int> insertConsulta(Consulta c) async => (await database).insert("consultas", c.toMap());

    //Get Consulta por Pet
    Future<List<Consulta>> getConsultaPorPet(int petId) async{
        final List<Map<String,dynamic>> maps = await (await database).query("consultas", where: "petId = ?", whereArgs: [petId], orderBy: "dataHora DESC" );
        return List.generate(maps.length, (e)=>Consulta.fromMap(maps[e]));
    }


}