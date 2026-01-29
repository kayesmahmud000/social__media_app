class PostModal {
  final int? id;
  final int userId;
  final String? content;
  final String? imagePath;
  final String timeStamp;
  final String? userName;
  final String? userAvatar;

  PostModal({
    this.id,
    required this.userId,
    required this.content,
    this.imagePath,
    required this.timeStamp,
    this.userName,
    this.userAvatar,
  });


PostModal copyWith({
  int ?id,
  int? userId,
  String? content,
  String ?imagePath,
  String ?userName,
  String ?userAvatar,
  String ?timeStamp
}){
return PostModal(id: id?? this.id, userId: userId ?? this.userId, content: content ?? this.content,
imagePath: imagePath?? this.imagePath,
userName: userName?? this.userName , userAvatar: userAvatar?? this.userAvatar,
 timeStamp: timeStamp ?? this.timeStamp);
}

   Map<String, dynamic> toMap(){
    return {
      'userId':userId,
      'content': content,
      'image_path':imagePath,
      'time_stamp': timeStamp
    };
   }

   factory PostModal.fromMap(Map<String,dynamic> data){
    return PostModal(
      id: data['id'],
      userId: data['userId'],
      content: data['content'],
      imagePath: data['image_path'],
      timeStamp: data['time_stamp'],
      userName: data['username'],
      userAvatar: data['profile_url']
    );

    }

}
