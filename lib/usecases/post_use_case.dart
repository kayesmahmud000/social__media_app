class PostDTO {
  final int userId;
 final String?content;
 final String? imagePath;
 final String timeStamp;

  PostDTO({required this.userId,  this.content,  this.imagePath, required this.timeStamp});

}