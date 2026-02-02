class CommentDTO{
  final int postId;
  final int userId;
  final String content;
  final String timeStamp;

  CommentDTO({required this.postId, required this.userId, required this.content, required this.timeStamp});


}