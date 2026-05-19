//ajudante de conexão com o DataBase

import 'package:exemplo_sqflite/nota_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotaDbhelper {
  //atributos
  static const String db_nome = "notas.db";
  static const String table_nome = "notas";
  static const String create_table = """CREATE TABLE IF NOT EXISTS $table_nome(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    conteudo TEXT NOT NULL)""";

  //MÉTODO DE CONEXÃO
  //método do tipo future (Async) para retornar o DB
  Future<Database> _getDB() async {
    return openDatabase(
      //colocar o endereço do DB
      join(await getDatabasesPath(), db_nome),
      onCreate: (db, version) {
        return db.execute(create_table);
      },
      version: 1,
    );
    //retorna o DB no final
  }

  //CRUD do DB (Controller)

  //create
  void create(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.insert(table_nome, nota.toMap());
    } catch (e) {
      print(e);
      return;
    }
  }

  //read
  Future<List<Nota>> getNotas() async {
    try {
      final Database db = await _getDB(); //estabelece a conexão
      final List<Map<String, dynamic>> maps = await db.query(
        table_nome,
      ); // pega todos os dados do DB
      //converter o Map em List<Nota>
      return List.generate(
        maps.length,
        (e) => Nota.fromMap(maps[e]),
      ); //retorna a lista com os objs
    } catch (e) {
      print(e); //mostra o erro
      return []; // retorna uma lista vazia
    }
  }

  //update
  void updateNota(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.update(
        table_nome,
        nota.toMap(),
        where: "id = ?",
        whereArgs: [nota.id],
      );
      //atualiza a nota a partir do id
    } catch (e) {
      print(e);
      return;
    }
  }

  //delete
  void deleteNota(int id) async {
    try {
      final Database db = await _getDB();
      await db.delete(table_nome, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      return;
    }
  }
}
