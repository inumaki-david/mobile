import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/registro_model.dart'; // Importa o modelo criado no Passo 1

// Classe Singleton responsável por conectar, inicializar e manipular o SQLite.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Retorna a instância do banco. Se não existir, inicializa uma nova.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Configura o caminho do arquivo .db e cria a tabela na primeira execução.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'senai_checkin.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE registros(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data_hora TEXT,
            latitude REAL,
            longitude REAL,
            observacao TEXT,
            caminho_da_foto TEXT
          )
          ''',
        );
      },
    );
  }

  // Insere um novo objeto Registro na tabela 'registros'.
  Future<void> inserirRegistro(Registro registro) async {
    final db = await database;
    await db.insert(
      'registros', 
      registro.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Busca todos os registros salvos e os converte de Map para Lista de objetos Registro.
  Future<List<Registro>> listarRegistros() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('registros', orderBy: 'id DESC');
    
    return List.generate(maps.length, (i) {
      return Registro(
        id: maps[i]['id'],
        dataHora: maps[i]['data_hora'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        observacao: maps[i]['observacao'],
        caminhoFoto: maps[i]['caminho_da_foto'],
      );
    });
  }
}