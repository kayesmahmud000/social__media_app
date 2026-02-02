import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/db_service.dart';
import 'package:social_media_app/usecases/post_use_case.dart';

class PostRepository extends MainRepository {
  @override
  String get tableName => DbService.TABLE_POST;

  Future<PostModel?> createPost(PostDTO postDTO) async {
    var post = PostModel(
      userId: postDTO.userId,
      content: postDTO.content,
      imagePath: postDTO.imagePath,
      timeStamp: postDTO.timeStamp,
    );
    var postId = await insert(post.toMap());

    var newPost = post.copyWith(id: postId);

    return newPost;
  }

 Future<List<PostModel>> getAllPost(int currentUserId) async {
  final database = await db;

  final List<Map<String, dynamic>> maps = await database.rawQuery('''
SELECT 
      p.*, 
      u.${DbService.COL_USER_NAME} AS username, 
      u.${DbService.COL_USER_PROFILE_PIC_URL} AS profile_url,
      
  
      (SELECT COUNT(*) FROM ${DbService.TABLE_LIKE} l 
       WHERE l.${DbService.COL_LIKE_POST_ID} = p.${DbService.COL_POST_ID}) AS like_count,
       
     
      (SELECT COUNT(*) FROM ${DbService.TABLE_COMMENT} c 
       WHERE c.${DbService.COL_COMMENT_POST_ID} = p.${DbService.COL_POST_ID}) AS comment_count,
       
     
      (SELECT COUNT(*) FROM ${DbService.TABLE_LIKE} l 
       WHERE l.${DbService.COL_LIKE_POST_ID} = p.${DbService.COL_POST_ID} 
       AND l.${DbService.COL_LIKE_USER_ID} = ?) AS is_liked
       
    FROM ${DbService.TABLE_POST} p
    INNER JOIN ${DbService.TABLE_USER} u ON p.${DbService.COL_POST_USER_ID} = u.${DbService.COL_USER_ID}
    ORDER BY p.${DbService.COL_POST_ID} DESC
  ''');

  return List.generate(maps.length, (i) => PostModel.fromMap(maps[i]));
}

Future<bool> deletePost (int id) async{
 int deleteId = await delete(id);
 return deleteId>0;
}


Future<bool> toggleLike(int postId, int userId) async {
  final database = await db;

  List<Map> result = await database.query(
    DbService.TABLE_LIKE,
    where: '${DbService.COL_LIKE_POST_ID} = ? AND ${DbService.COL_LIKE_USER_ID} = ?',
    whereArgs: [postId, userId],
  );

  if (result.isEmpty) {
  
    await database.insert(DbService.TABLE_LIKE, {
      DbService.COL_LIKE_POST_ID: postId,
      DbService.COL_LIKE_USER_ID: userId,
    });
    return true;
  } else {
   
    await database.delete(
      DbService.TABLE_LIKE,
      where: '${DbService.COL_LIKE_POST_ID} = ? AND ${DbService.COL_LIKE_USER_ID} = ?',
      whereArgs: [postId, userId],
    );
    return false;
  }
}
}
