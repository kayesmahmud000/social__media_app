import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/comment_service.dart';
import 'package:social_media_app/usecases/comment_use_case.dart';

class CommentRepository extends MainRepository {
  @override
  String get tableName => CommentService.TABLE_COMMENT;

  Future<CommentModel?> insertComment(CommentDTO commentDTO) async {
    var comment = CommentModel(
      userId: commentDTO.userId,
      postId: commentDTO.postId,
      content: commentDTO.content,
      timeStamp: commentDTO.timeStamp,
    );

    int commentId = await insert(comment.toMap());

    var newComment = comment.copyWith(id: commentId);

    return newComment;
  }

  Future<List<CommentModel>> getAllComment(int postId) async {
    final maps = await queryRaw(CommentService.selectAllCommentsQuery, [
      postId,
    ]);
    return maps.map((map) => CommentModel.fromMap(map)).toList();
}
}