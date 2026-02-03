import 'package:social_media_app/services/comment_service.dart';
import 'package:social_media_app/services/like_service.dart';
import 'package:social_media_app/services/user__service.dart';

class PostService {
   // Post Table
  static const TABLE_POST = 'posts';
  static const COL_POST_ID = 'id';
  static const COL_POST_USER_ID = 'user_id';
  static const COL_POST_CONTENT = 'content';
  static const COL_POST_IMAGE_PATH = 'image_path';
  static const COL_POST_TIME_STAMP = 'time_stamp';

  static const String createTable = '''
      CREATE TABLE $TABLE_POST (
        $COL_POST_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COL_POST_USER_ID INTEGER NOT NULL, 
        $COL_POST_CONTENT TEXT, 
        $COL_POST_IMAGE_PATH TEXT, 
        $COL_POST_TIME_STAMP TEXT, 
      FOREIGN KEY ($COL_POST_USER_ID) REFERENCES ${UserService.TABLE_USER} (${UserService.COL_USER_ID}) ON DELETE CASCADE
      )
    ''';


  static const String selectAllPostsQuery = '''
    SELECT 
      p.*, 
      u.${UserService.COL_USER_NAME} AS username, 
      u.${UserService.COL_USER_PROFILE_PIC_URL} AS profile_url,
      (SELECT COUNT(*) FROM ${LikeService.TABLE_LIKE} l WHERE l.${LikeService.COL_LIKE_POST_ID} = p.${PostService.COL_POST_ID}) AS like_count,
      (SELECT COUNT(*) FROM ${CommentService.TABLE_COMMENT} c WHERE c.${CommentService.COL_COMMENT_POST_ID} = p.${PostService.COL_POST_ID}) AS comment_count,
      (SELECT COUNT(*) FROM ${LikeService.TABLE_LIKE} l WHERE l.${LikeService.COL_LIKE_POST_ID} = p.${PostService.COL_POST_ID} AND l.${LikeService.COL_LIKE_USER_ID} = ?) AS is_liked
    FROM $TABLE_POST p
    INNER JOIN ${UserService.TABLE_USER} u ON p.$COL_POST_USER_ID = u.${UserService.COL_USER_ID}
    ORDER BY p.$COL_POST_ID DESC
  ''';

  static const String selectPostByIdQuery = '''
    SELECT 
      p.*, 
      u.${UserService.COL_USER_NAME} AS username, 
      u.${UserService.COL_USER_PROFILE_PIC_URL} AS profile_url,
      (SELECT COUNT(*) FROM ${LikeService.TABLE_LIKE} l WHERE l.${LikeService.COL_LIKE_POST_ID} = p.${PostService.COL_POST_ID}) AS like_count,
      (SELECT COUNT(*) FROM ${CommentService.TABLE_COMMENT} c WHERE c.${CommentService.COL_COMMENT_POST_ID} = p.${PostService.COL_POST_ID}) AS comment_count,
      (SELECT COUNT(*) FROM ${LikeService.TABLE_LIKE} l WHERE l.${LikeService.COL_LIKE_POST_ID} = p.${PostService.COL_POST_ID} AND l.${LikeService.COL_LIKE_USER_ID} = ?) AS is_liked
    FROM $TABLE_POST p
    INNER JOIN ${UserService.TABLE_USER} u ON p.$COL_POST_USER_ID = u.${UserService.COL_USER_ID}
    WHERE p.$COL_POST_ID = ?
  ''';
}