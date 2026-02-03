import 'package:social_media_app/exception/database_custom_exception.dart';
import 'package:social_media_app/helper/security_helper.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';

import 'package:social_media_app/services/user__service.dart';
import 'package:social_media_app/usecases/user_login_use_case.dart';
import 'package:social_media_app/usecases/user_sign_up_usecase.dart';

class UserRepository extends MainRepository<User> {
  @override
  String get tableName => UserService.TABLE_USER;

  Future<User?> signUp(UserSignUpDTO userDTO) async {
    String hashedPass = SecurityHelper.hashedPassword(userDTO.password);

    var user = User(
      email: userDTO.email,
      pass: hashedPass,
      userName: userDTO.username,
    );

    var userId = await insert(user.toMap());

    var newUser = user.copyWith(id: userId);

    return newUser;
  }

  Future<User?> getUserById(int id) async {
    final map = await getById(id);
    if (map != null) {
      return User.fromMap(map);
    }
    return null;
  }

  Future<User?> login(UserLoginDTO userDTO) async {
    try {
      String hashedPass = SecurityHelper.hashedPassword(userDTO.password);
      final database = await db;
      final List<Map<String, dynamic>> maps = await database.query(
        tableName,
        where:
            "${UserService.COL_USER_EMAIL} = ? AND ${UserService.COL_USER_PASS} = ?",
        whereArgs: [userDTO.email, hashedPass],
      );
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        throw DatabaseCustomException('Invalid email or password');
      }
    } catch (e) {
      rethrow;
    }
  }
}
