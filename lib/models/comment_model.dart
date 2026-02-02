class CommentModel {
  final int? id;
  final int userId;
  final int postId;
  final String content;
  final String timeStamp;
  final String? userName;
  final String? userAvatar;

  CommentModel({
    this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.timeStamp,
    this.userName,
    this.userAvatar,
  });

  CommentModel copyWith({
    int? id,
    int? userId,
    int? postId,
    String? content,
    String? userName,
    String? userAvatar,
    String? timeStamp,
  }) {
    return CommentModel(
      id: id?? this.id,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'post_id': postId,
      'content': content,
      'time_stamp': timeStamp,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      id: data['id'],
      userId: data['user_id'],
      postId: data['post_id'],
      content: data['content'],
      userName: data['username'],
      userAvatar: data['profile_url'],
      timeStamp: data['time_stamp'],
    );
  }
}
