import 'package:social_media_app/models/story_model.dart';
import 'package:social_media_app/repositories/main_repository.dart';
import 'package:social_media_app/services/story_service.dart';
import 'package:social_media_app/usecases/story_use_case.dart';
import 'package:sqflite/utils/utils.dart'; 
class StroyRepository extends MainRepository {
  @override
  String get tableName => StoryService.TABLE_STORY;

  // ১. স্টোরি তৈরি করা
  Future<StoryModel?> createStory(StoryDTO storyDTO) async {
    var story = StoryModel(
      userId: storyDTO.userId,
      mediaUrl: storyDTO.mediaUrl,
      caption: storyDTO.caption,
      timeStamp: storyDTO.timeStamp,
    );

    var stroyId = await insert(story.toMap());
    return story.copyWith(id: stroyId);
  }


  Future<List<StoryModel>> getStories() async {
    try {
      final String timeLimit = DateTime.now()
          .subtract(const Duration(hours: 24))
          .toIso8601String();

      final maps = await queryRaw(StoryService.selectActiveStoriesWithUser(timeLimit));

      return maps.map((map) => StoryModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  
  Future<void> markStoryAsViewed(int storyId, int viewerId) async {
    try {
      final  database= await db; 

     
      final List<Map<String, dynamic>> existing = await database.query(
        StoryService.TABLE_VIEWS,
        where: '${StoryService.COL_VIEWS_STORY_ID} = ? AND ${StoryService.COL_VIEWER_ID} = ?',
        whereArgs: [storyId, viewerId],
      );

      if (existing.isEmpty) {
        await database.insert(StoryService.TABLE_VIEWS, {
          StoryService.COL_VIEWS_STORY_ID: storyId,
          StoryService.COL_VIEWER_ID: viewerId,
          StoryService.COL_VIEWS_TIME: DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print("Error marking story as viewed: $e");
    }
  }


  Future<int> getStoryViewCount(int storyId) async {
    try {
      final database = await db;
      final result = await database.rawQuery(
        'SELECT COUNT(*) as count FROM ${StoryService.TABLE_VIEWS} WHERE ${StoryService.COL_VIEWS_STORY_ID} = ?',
        [storyId],
      );
      return firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  
  Future<List<Map<String, dynamic>>> getStoryViewers(int storyId) async {
    try {
      return await queryRaw(StoryService.selectStoryViewers(storyId));
    } catch (e) {
      return [];
    }
  }
}