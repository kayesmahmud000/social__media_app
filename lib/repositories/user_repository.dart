import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/db_service.dart';

class UserRepository extends MainRepository<User> {
  @override
  // TODO: implement tableName
  String get tableName => DbService.TABLE_USER;

  Future<int> signUp(User user) async {
    var userId = await insert(user.toMap());

    return userId;
  }

  Future<User?> getUserById(int id) async {
    final map = await getById(id); 
    if (map != null) {
      return User.fromMap(map);
    }
    return null;
  }

 
  Future<User?> login(String email, String pass) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      tableName,
      where: "${DbService.COL_USER_EMAIL} = ? AND ${DbService.COL_USER_PASS} = ?",
      whereArgs: [email, pass],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }


}
