import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/db_service.dart';
import 'package:social_media_app/usecases/comment_use_case.dart';

class CommentRepository extends MainRepository {
  @override

  String get tableName => DbService.TABLE_COMMENT;

  Future<CommentModel?> insertComment(CommentDTO commentDTO)async{
    var comment =CommentModel(userId: commentDTO.userId, postId: commentDTO.postId, content: commentDTO.content, timeStamp:commentDTO.timeStamp);

   int commentId = await insert(comment.toMap()); 

   var newComment = comment.copyWith
   (id: commentId);

   return newComment;
  }

Future<List<CommentModel>> getAllComment(int postId)async{
  final database =await db;

  final List<Map<String, dynamic>> maps = await database.rawQuery('''
      SELECT c.*, u.${DbService.COL_USER_NAME} as username, u.${DbService.COL_USER_PROFILE_PIC_URL} as profile_url
      FROM ${DbService.TABLE_COMMENT} c
      INNER JOIN ${DbService.TABLE_USER} u ON c.${DbService.COL_COMMENT_USER_ID} = u.${DbService.COL_USER_ID}
      WHERE c.${DbService.COL_COMMENT_POST_ID} = ?
      ORDER BY c.${DbService.COL_COMMENT_ID} DESC
    ''', [postId]);

    return List.generate(maps.length, (i) => CommentModel.fromMap(maps[i]));
}
}