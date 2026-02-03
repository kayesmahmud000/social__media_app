import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/services/user__service.dart';

class CommentService {
   // Comment Table
  static const TABLE_COMMENT = 'comments';
  static const COL_COMMENT_ID = 'id';
  static const COL_COMMENT_POST_ID = 'post_id';
  static const COL_COMMENT_USER_ID = 'user_id';
  static const COL_COMMENT_CONTENT = 'content';
  static const COL_COMMENT_TIME_STAMP = 'time_stamp';

   static const String createTable = '''
      CREATE TABLE $TABLE_COMMENT (
        $COL_COMMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COL_COMMENT_POST_ID INTEGER NOT NULL, 
        $COL_COMMENT_USER_ID INTEGER NOT NULL, 
        $COL_COMMENT_CONTENT TEXT, 
        $COL_COMMENT_TIME_STAMP TEXT, 
        FOREIGN KEY ($COL_COMMENT_USER_ID) REFERENCES ${UserService.TABLE_USER} (${UserService.COL_USER_ID}) ON DELETE CASCADE,
        FOREIGN KEY ($COL_COMMENT_POST_ID) REFERENCES ${PostService.TABLE_POST} (${PostService.COL_POST_ID}) ON DELETE CASCADE
      )
    ''';
   static const String selectAllCommentsQuery =  '''
      SELECT c.*, u.${UserService.COL_USER_NAME} as username, u.${UserService.COL_USER_PROFILE_PIC_URL} as profile_url
      FROM ${CommentService.TABLE_COMMENT} c
      INNER JOIN ${UserService.TABLE_USER} u ON c.${CommentService.COL_COMMENT_USER_ID} = u.${UserService.COL_USER_ID}
      WHERE c.${CommentService.COL_COMMENT_POST_ID} = ?
      ORDER BY c.${CommentService.COL_COMMENT_ID} DESC
    ''';


}