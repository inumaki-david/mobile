import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/visitante_model.dart';
import '../models/visita_model.dart';

class DatabaseHelper {
  static const _databaseName = "ControleVisitantes.db";
  static const _databaseVersion = 1;

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      // Habilita as chaves estrangeiras no SQLite
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Criação das tabelas
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE visitantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        documento TEXT UNIQUE NOT NULL,
        data_nascimento TEXT NOT NULL,
        endereco TEXT NOT NULL,
        tipo TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE visitas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visitante_id INTEGER NOT NULL,
        data_entrada TEXT NOT NULL,
        data_saida TEXT,
        motivo TEXT NOT NULL,
        unidade_destino TEXT NOT NULL,
        FOREIGN KEY (visitante_id) REFERENCES visitantes (id) ON DELETE CASCADE
      )
    ''');
  }

  // ==========================================
  // CRUD - VISITANTES
  // ==========================================
  
  Future<int> insertVisitante(Visitante visitante) async {
    Database db = await instance.database;
    try {
      // Exemplo de uso: insertVisitante(Visitante(nome: 'Evelyn', documento: '123', idade: 20, endereco: 'Rua A'));
      return await db.insert('visitantes', visitante.toMap());
    } catch (e) {
      print("Erro ao inserir visitante: $e");
      return -1; // Retorna -1 em caso de erro (ex: documento duplicado)
    }
  }

  Future<List<Visitante>> getVisitantes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('visitantes', orderBy: 'nome ASC');
    return List.generate(maps.length, (i) {
      return Visitante.fromMap(maps[i]);
    });
  }

  Future<int> deleteVisitante(int id) async {
    Database db = await instance.database;
    return await db.delete('visitantes', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // CRUD - VISITAS
  // ==========================================
  
  Future<int> insertVisita(Visita visita) async {
    Database db = await instance.database;
    // Exemplo: insertVisita(Visita(visitanteId: 1, dataEntrada: DateTime.now().toString(), motivo: 'Reunião com Rodrigo'));
    return await db.insert('visitas', visita.toMap());
  }

  Future<List<Visita>> getVisitasPorVisitante(int visitanteId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'visitas',
      where: 'visitante_id = ?',
      whereArgs: [visitanteId],
      orderBy: 'data_entrada DESC',
    );
    return List.generate(maps.length, (i) {
      return Visita.fromMap(maps[i]);
    });
  }

  Future<int> registrarSaida(int visitaId, String dataSaida) async {
    Database db = await instance.database;
    return await db.update(
      'visitas',
      {'data_saida': dataSaida},
      where: 'id = ?',
      whereArgs: [visitaId],
    );
  }
}