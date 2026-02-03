import 'package:flutter/foundation.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/repositories/post_repository.dart';
import 'package:social_media_app/usecases/post_use_case.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  List<PostModel> _posts = [];
  bool _isLoading = false;
PostModel? _selectedPost;


  List<PostModel> get posts => _posts;
  PostModel? get selectedPost => _selectedPost; 
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

Future<PostModel?> getPostById(int id, int currentUserId) async {
  _isLoading = true;
  _selectedPost = null; 
  notifyListeners();
  
  try {
    PostModel? post = await _postRepository.getPostById(id, currentUserId: currentUserId);
    if (post != null) {
      _selectedPost = post;
    }
    return post; 
  } catch (e) {
    debugPrint("Error fetching single post: $e");
    return null; 
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

void updatePostInList(int postId) async {
  
  PostModel? updatedPost = await getPostById(postId, _posts.firstWhere((p) => p.id == postId).userId);

  if (updatedPost != null) {
   
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = updatedPost; 
      notifyListeners(); 
    }
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
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final isCurrentlyLiked = _posts[index].isLiked;
    final currentLikes = _posts[index].likeCount;

    _posts[index] = _posts[index].copyWith(
      isLiked: !isCurrentlyLiked,
      likeCount: isCurrentlyLiked ? currentLikes - 1 : currentLikes + 1,
    );
    notifyListeners();

    try {
      await _postRepository.toggleLike(postId, userId);
    } catch (e) {
      _posts[index] = _posts[index].copyWith(
        isLiked: isCurrentlyLiked,
        likeCount: currentLikes,
      );
      notifyListeners();
    }
  }
}
