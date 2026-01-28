import 'package:social_media_app/services/db_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class MainRepository<T> {
  String get tableName;

  Future<Database> get db async => await DbService().database;

  Future<int> insert(Map<String, dynamic> data) async {
    final database = await db;
    return await database.insert(tableName, data);
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    final database = await db;
    return await database.update(
      tableName,
      data,
      where: 'id =?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final database = await db;
    return await database.delete(tableName, where: 'id =?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final database = await db;

    return await database.query(tableName);
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final database = await db;

    final List<Map<String, dynamic>> map = await database.query(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    );

    if (map.isNotEmpty) {
      return map.first;
    }
    return null;
  }
}
