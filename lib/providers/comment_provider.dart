import 'package:flutter/foundation.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/repositories/comment_repository.dart';
import 'package:social_media_app/usecases/comment_use_case.dart';

class CommentProvider extends ChangeNotifier{
  final CommentRepository _commentRepository =CommentRepository();

 List<CommentModel> _comments =[];
 bool _isLoading =false;

 List<CommentModel> get comments => _comments;
 bool get isLoading => _isLoading;


Future<void> getAllComment (int postId)async{
  _isLoading = true;
    notifyListeners();

  try{
    _comments = await _commentRepository.getAllComment(postId);
  }catch (e){
    debugPrint('Error fetching comment: $e');
  }finally {
      _isLoading = false;
      notifyListeners();
    }

}

Future<bool> createComment(CommentDTO commentDTO)async{
  try{
    CommentModel? newComment =await _commentRepository.insertComment(commentDTO);

   if (newComment != null) {
        await getAllComment(newComment.postId);
        return true;
      }

  }catch (e){
    debugPrint('Error creating comment $e');
  }
      return false;
}
}