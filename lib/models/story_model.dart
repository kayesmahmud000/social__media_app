class StoryModel {
  final int? id;
  final int userId;
  final String? mediaUrl;
  final String? caption;
  final String timeStamp;

  StoryModel({
    this.id,
    required this.userId,
    this.mediaUrl,
    this.caption,
    required this.timeStamp,
  });

  StoryModel copyWith({
    int? id,
    int? userId,
    String? mediaUrl,
    String? caption,
    String? timeStamp,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      caption: caption ?? this.caption,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'media_url': mediaUrl,
      'caption': caption,
      'time_stamp': timeStamp,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> data) {
    return StoryModel(
      id: data['id'],
      userId: data['user_id'],
      mediaUrl: data['media_url'],
      caption: data['caption'],
      timeStamp: data['time_stamp'],
    );
  }
}
