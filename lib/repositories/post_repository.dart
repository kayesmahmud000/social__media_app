import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/db_service.dart';
import 'package:social_media_app/usecases/post_use_case.dart';

class PostRepository extends MainRepository {
  @override
  String get tableName => DbService.TABLE_POST;

  Future<PostModel?> createPost(PostDTO postDTO)async {
    
    var post = PostModel(
      userId: postDTO.userId,
      content: postDTO.content,
      imagePath: postDTO.imagePath,
      timeStamp: postDTO.timeStamp,
    );

    var postId = await insert(post.toMap());

    var newPost = post.copyWith(
      id: postId
    );
    
    return newPost;

    
  }

}
