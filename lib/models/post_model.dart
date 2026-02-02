class PostModel {
  final int? id;
  final int userId;
  final String? content;
  final String? imagePath;
  final String timeStamp;
  final String? userName;
  final String? userAvatar;
  final int likeCount;
  final bool isLiked;
  final int? commentCount;

  PostModel({
    this.id,
    required this.userId,
    this.content,
    this.imagePath,
    required this.timeStamp,
    this.userName,
    this.userAvatar,
    this.likeCount = 0,
    this.isLiked = false,
    this.commentCount
   
  });

  PostModel copyWith({
    int? id,
    int? userId,
    String? content,
    String? imagePath,
    String? userName,
    String? userAvatar,
    String? timeStamp,
    int? likeCount,
    bool? isLiked,
    int? commentCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      timeStamp: timeStamp ?? this.timeStamp,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      commentCount: commentCount?? this.commentCount
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'content': content,
      'image_path': imagePath,
      'time_stamp': timeStamp,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      id: data['id'],
      userId: data['user_id'],
      content: data['content'],
      userName: data['username'],
      imagePath: data['image_path'],
      timeStamp: data['time_stamp'],
      userAvatar: data['profile_url'],

      likeCount: data['like_count'] ?? 0,

      isLiked: (data['is_liked'] ?? 0) == 1,
      commentCount: data['comment_count'] ?? 0,
    );
  }
}
