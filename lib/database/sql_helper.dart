import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Criacao das tabelas
  static const tableDoadores = """CREATE TABLE doadores(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        obs TEXT,
        createdAt TEXT
      );
      """;

  static const tableDonatarios = """CREATE TABLE donatarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        obs TEXT,
        createdAt TEXT
      );
      """;

  static const tableEntradas = """CREATE TABLE entradas(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        valor REAL,
        obs TEXT,
        createdAt TEXT
      );
      """;

  static const tableSaidas = """CREATE TABLE saidas(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        valor REAL,
        obs TEXT,
        createdAt TEXT
      );
      """;

  // funcao abrir banco de dados e criar as tabelas
  static Future<sql.Database> db() async {
    return await sql.openDatabase(
      'bando_de_dados.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await database.execute(tableDoadores);
        await database.execute(tableDonatarios);
        await database.execute(tableEntradas);
        await database.execute(tableSaidas);
      },
    );
  }

// FUNÇOES DOS DOADORES
  // Criar um Doador
  static Future<int> createDoador(String nome, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };
    final id = await db.insert('doadores', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Ler todos os Doadores
  static Future<List<Map<String, dynamic>>> getDoadores() async {
    final db = await SQLHelper.db();
    return db.query('doadores', orderBy: "id");
  }

  // Ler um item pelo id
  static Future<List<Map<String, dynamic>>> getDoador(int id) async {
    final db = await SQLHelper.db();
    return db.query('doadores', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Editar pelo id
  static Future<int> updateDoador(int id, String nome, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };

    final result =
        await db.update('doadores', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Deletar
  static Future<void> deleteDoador(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("doadores", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("algo deu errado: $err");
    }
  }

  //FUNÇOES DOS DONATARIOS

  // Criar um Donatario
  static Future<int> createDonatario(String nome, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };
    final id = await db.insert('donatarios', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Ler todos os itens (lista donatarios)
  static Future<List<Map<String, dynamic>>> getDonatarios() async {
    final db = await SQLHelper.db();
    return db.query('donatarios', orderBy: "id");
  }

  // Ler apenas um item pelo id
  static Future<List<Map<String, dynamic>>> getDonatario(int id) async {
    final db = await SQLHelper.db();
    return db.query('donatarios', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Editar pelo id
  static Future<int> updateDonatario(int id, String nome, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };

    final result =
        await db.update('donatarios', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Deletar
  static Future<void> deleteDonatario(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("donatarios", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("algo deu errado: $err");
    }
  }

  //FUNÇOES DE ENTRADA

  // Criar uma entrada
  static Future<int> createEntrada(
      String nome, double valor, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'valor': valor,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };
    final id = await db.insert('entradas', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Ler todas as entradas
  static Future<List<Map<String, dynamic>>> getEntradas() async {
    final db = await SQLHelper.db();
    return db.query('entradas', orderBy: "id DESC");
  }

  // Ler apenas um item por id
  static Future<List<Map<String, dynamic>>> getEntrada(int id) async {
    final db = await SQLHelper.db();
    return db.query('entradas', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Editar pelo id
  static Future<int> updateEntrada(
      int id, String nome, double valor, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'valor': valor,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };

    final result =
        await db.update('entradas', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Deletar
  static Future<void> deleteEntradas(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("entradas", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("algo deu errado: $err");
    }
  }

  //FUNÇOES DE SAÍDAS

  // Criar uma saida
  static Future<int> createSaida(String nome, double valor, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'valor': valor,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };
    final id = await db.insert('saidas', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Ler todas as saidas
  static Future<List<Map<String, dynamic>>> getSaidas() async {
    final db = await SQLHelper.db();
    return db.query('saidas', orderBy: "id DESC");
  }

  // Ler um item pelo id
  static Future<List<Map<String, dynamic>>> getSaida(int id) async {
    final db = await SQLHelper.db();
    return db.query('saidas', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Editar um item pelo id
  static Future<int> updateSaida(
      int id, String nome, double valor, String? obs) async {
    final db = await SQLHelper.db();

    final data = {
      'nome': nome,
      'valor': valor,
      'obs': obs,
      'createdAt': DateTime.now().toLocal().toString()
    };

    final result =
        await db.update('saidas', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Deletar
  static Future<void> deleteSaida(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("saidas", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("algo deu errado: $err");
    }
  }

  //Querys Pagina Inicial

  static Future<List<Map<String, dynamic>>> getEntradasI() async {
    final db = await SQLHelper.db();
    return db.query('entradas', orderBy: "id DESC", limit: 7);
  }

  //Querys Pagina Inicial

  static Future<List<Map<String, dynamic>>> getSaidasI() async {
    final db = await SQLHelper.db();
    return db.query('saidas', orderBy: "id DESC", limit: 7);
  }

  //  soma
  static Future somaEntradas() async {
    final db = await SQLHelper.db();
    var result = await db.rawQuery("SELECT SUM(valor) FROM entradas");
    var value = result[0]["SUM(valor)"];

    return value;
  }

  //  soma
  static Future somaSaidas() async {
    final db = await SQLHelper.db();
    var result = await db.rawQuery("SELECT SUM(valor) FROM saidas");
    var value = result[0]["SUM(valor)"];

    return value;
  }

}
