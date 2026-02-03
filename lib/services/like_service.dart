import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/services/user__service.dart';

class LikeService {
    // Like Table
  static const TABLE_LIKE = 'likes';
  static const COL_LIKE_POST_ID = 'post_id';
  static const COL_LIKE_USER_ID = 'user_id';

    static const String createTable ='''
      CREATE TABLE $TABLE_LIKE (
        $COL_LIKE_POST_ID INTEGER, 
        $COL_LIKE_USER_ID INTEGER, 
        PRIMARY KEY ($COL_LIKE_POST_ID, $COL_LIKE_USER_ID), 
        FOREIGN KEY ($COL_LIKE_USER_ID) REFERENCES ${UserService.TABLE_USER} (${UserService.COL_USER_ID}) ON DELETE CASCADE, 
        FOREIGN KEY ($COL_LIKE_POST_ID) REFERENCES ${PostService.TABLE_POST} (${PostService.COL_POST_ID}) ON DELETE CASCADE
      )
    ''';
}