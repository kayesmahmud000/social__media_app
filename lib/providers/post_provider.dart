import 'package:flutter/foundation.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/repositories/post_repository.dart';
import 'package:social_media_app/usecases/post_use_case.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  List<PostModel> _posts = [];
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  
  Future<void> getPosts(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _posts = await _postRepository.getAllPost(userId);
    } catch (e) {
      debugPrint("Error loading posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // upload post
  Future<bool> createPost(PostDTO postDTO) async {
    try {
      PostModel? newPost = await _postRepository.createPost(postDTO);
      if (newPost != null) {
        await getPosts(postDTO.userId);
        return true;
      }
    } catch (e) {
      debugPrint("Error sharing post: $e");
    }
    return false;
  }

  
  Future<void> deletePost(int id, int userId) async {
    try {
      bool check = await _postRepository.deletePost(id);
      if (check) {
        await getPosts(userId);
      }
    } catch (e) {
      debugPrint("Error Delete post: $e");
    }
  }

 
  Future<void> handleLike(int postId, int userId) async {
    try {
      await _postRepository.toggleLike(postId, userId);
      await getPosts(userId); 
    } catch (e) {
      debugPrint("Error Liking post: $e");
    }
  }
}