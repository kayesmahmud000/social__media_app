import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  static Database? _database;

  // user table
  static const TABLE_USER = 'users';
  static const COL_USER_ID = 'id';
  static const COL_USER_NAME = 'username';
  static const COL_USER_PASS = 'password';
  static const COL_USER_EMAIL = 'email';
  static const COL_USER_PROFILE_PIC_URL = 'profile_url';

  // Post Table
  static const TABLE_POST = 'posts';
  static const COL_POST_ID = 'id';
  static const COL_POST_USER_ID = 'user_id';
  static const COL_POST_CONTENT = 'content';
  static const COL_POST_IMAGE_PATH = 'image_path';
  static const COL_POST_TIME_STAMP = 'time_stamp';

  // Comment Table
  static const TABLE_COMMENT = 'comments';
  static const COL_COMMENT_ID = 'id';
  static const COL_COMMENT_POST_ID = 'post_id';
  static const COL_COMMENT_USER_ID = 'user_id';
  static const COL_COMMENT_CONTENT = 'content';
  static const COL_COMMENT_TIME_STAMP = 'time_stamp';

  // Like Table
  static const TABLE_LIKE = 'likes';
  static const COL_LIKE_POST_ID = 'post_id';
  static const COL_LIKE_USER_ID = 'user_id';

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
      version: 2,
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

    await db.execute(
      "CREATE TABLE $TABLE_POST ($COL_POST_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COL_POST_USER_ID INTEGER NOT NULL , $COL_POST_CONTENT TEXT , $COL_POST_IMAGE_PATH TEXT , $COL_POST_TIME_STAMP TEXT, FOREIGN KEY ($COL_POST_USER_ID) REFERENCES $TABLE_USER ($COL_USER_ID) ON DELETE CASCADE )",
    );
    await db.execute(
      "CREATE TABLE $TABLE_COMMENT ($COL_COMMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,$COL_COMMENT_POST_ID INTEGER NOT NULL $COL_COMMENT_USER_ID INTEGER NOT NULL , $COL_COMMENT_CONTENT TEXT , $COL_COMMENT_TIME_STAMP TEXT, FOREIGN KEY ($COL_COMMENT_USER_ID) REFERENCES $TABLE_USER ($COL_USER_ID) ON DELETE CASCADE,FOREIGN KEY ($COL_COMMENT_POST_ID) REFERENCES $TABLE_POST ($COL_POST_ID) ON DELETE CASCADE )",
    );

    await db.execute(
      " CREATE TABLE $TABLE_LIKE ($COL_LIKE_POST_ID INTEGER , $COL_LIKE_USER_ID INTEGER, PRIMARY KEY ($COL_LIKE_POST_ID , $COL_LIKE_USER_ID), FOREIGN KEY ($COL_LIKE_USER_ID) REFERENCES $TABLE_USER ($COL_USER_ID) ON DELETE CASCADE , FOREIGN KEY ($COL_LIKE_POST_ID) REFERENCES $TABLE_POST ($COL_POST_ID) ON DELETE CASCADE)"
    );
  }
}
