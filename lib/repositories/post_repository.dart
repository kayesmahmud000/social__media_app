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

  Future<List<PostModel>> getAllPost() async {
    final database = await db;

    final List<Map<String, dynamic>> maps = await database.rawQuery(
      "SELECT $tableName.*, ${DbService.TABLE_USER}.${DbService.COL_USER_NAME}, ${DbService.TABLE_USER}.${DbService.COL_USER_PROFILE_PIC_URL} FROM ${DbService.TABLE_POST} INNER JOIN ${DbService.TABLE_USER} ON ${DbService.TABLE_POST}.${DbService.COL_POST_USER_ID}=${DbService.TABLE_USER}.${DbService.COL_USER_ID} ORDER BY ${DbService.TABLE_POST}.${DbService.COL_POST_ID} DESC",
    );

    return List.generate(maps.length, (i) {
      return PostModel.fromMap(maps[i]);
    });
  }

Future<bool> deletePost (int id) async{
 int deleteId = await delete(id);
 return deleteId>0;
}
}
