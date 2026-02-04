import 'package:social_media_app/exception/database_custom_exception.dart';
import 'package:social_media_app/services/db_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class MainRepository<T> {
  String get tableName;

  Future<Database> get db async => await DbService().database;

  Future<int> insert(Map<String, dynamic> data) async {
    try {
      final database = await db;
      return await database.insert(tableName, data);
    } catch (e) {
      if (e.toString().contains("UNIQUE")) {
        throw DatabaseCustomException('Email Already exist');
      }
      throw DatabaseCustomException('Something want wrong with database! ');
    }
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      final database = await db;
      return await database.update(
        tableName,
        data,
        where: 'id =?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> delete(int id) async {
    try {
      final database = await db;
      return await database.delete(tableName, where: 'id =?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> queryRaw(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    try {
      final database = await db;
      return await database.rawQuery(sql, arguments);
    } catch (e) {
      throw DatabaseCustomException('Error executing raw query: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final database = await db;

      return await database.query(tableName);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }
}
