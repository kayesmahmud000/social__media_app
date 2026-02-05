import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/services/comment_service.dart';
import 'package:social_media_app/services/like_service.dart';
import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/services/story_service.dart';
import 'package:social_media_app/services/user__service.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  static Database? _database;

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
    await db.execute(UserService.createTable);

    await db.execute(PostService.createTable);

    await db.execute(CommentService.createTable);

    await db.execute(LikeService.createTable);

    await db.execute(StoryService.createTable);
    
    await db.execute(StoryService.createViewsTable);
  }
}
