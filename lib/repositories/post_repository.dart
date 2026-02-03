import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/like_service.dart';
import 'package:social_media_app/services/post_service.dart';
import 'package:social_media_app/usecases/post_use_case.dart';

class PostRepository extends MainRepository {
  @override
  String get tableName => PostService.TABLE_POST;

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
    final maps = await queryRaw(PostService.selectAllPostsQuery, [
      currentUserId,
    ]);
    return maps.map((map) => PostModel.fromMap(map)).toList();
  }

  Future<bool> deletePost(int id) async {
    int deleteId = await delete(id);
    return deleteId > 0;
  }

  Future<PostModel?> getPostById(int postId, {int? currentUserId}) async {
    final maps = await queryRaw(PostService.selectPostByIdQuery, [
      currentUserId ?? 0,
      postId,
    ]);
    if (maps.isNotEmpty) {
      return PostModel.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> toggleLike(int postId, int userId) async {
    final database = await db;

    List<Map> result = await database.query(
      LikeService.TABLE_LIKE,
      where:
          '${LikeService.COL_LIKE_POST_ID} = ? AND ${LikeService.COL_LIKE_USER_ID} = ?',
      whereArgs: [postId, userId],
    );

    if (result.isEmpty) {
      await database.insert(LikeService.TABLE_LIKE, {
        LikeService.COL_LIKE_POST_ID: postId,
        LikeService.COL_LIKE_USER_ID: userId,
      });
      return true;
    } else {
      await database.delete(
        LikeService.TABLE_LIKE,
        where:
            '${LikeService.COL_LIKE_POST_ID} = ? AND ${LikeService.COL_LIKE_USER_ID} = ?',
        whereArgs: [postId, userId],
      );
      return false;
    }
  }
}
