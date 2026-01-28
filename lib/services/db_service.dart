import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  static Database? _database;
  static const TABLE_USER = 'users';
  static const COL_USER_ID = 'id';
  static const COL_USER_NAME = 'username';
  static const COL_USER_PASS = 'password';
  static const COL_USER_EMAIL = 'email';
  static const COL_USER_PROFILE_PIC_URL = 'profile_url';

  DbService._internal();

  factory DbService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database?> _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'social_media_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys =ON');
      },
    );
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $TABLE_USER ($COL_USER_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COL_USER_NAME TEXT NOT NULL, $COL_USER_EMAIL TEXT UNIQUE NOT NULL, $COL_USER_PASS TEXT NOT NULL, $COL_USER_PROFILE_PIC_URL TEXT)",
    );
   
  }
}
