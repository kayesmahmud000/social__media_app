import 'package:flutter/foundation.dart';
import 'package:social_media_app/models/story_model.dart';
import 'package:social_media_app/repositories/stroy_repository.dart';
import 'package:social_media_app/usecases/story_use_case.dart';

class StroyProvider extends ChangeNotifier {
  final StroyRepository _stroyRepository = StroyRepository();
  Map<int, List<StoryModel>> _groupedStories = {};
  bool _isLoading = false;

 
  final Map<int, int> _storyViewCounts = {};

  Map<int, List<StoryModel>> get groupedStories => _groupedStories;
  bool get isLoading => _isLoading;
  Map<int, int> get storyViewCounts => _storyViewCounts;

  Future<void> getAllStories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allStories = await _stroyRepository.getStories();
      _groupedStories = {};

      for (var story in allStories) {
        if (!_groupedStories.containsKey(story.userId)) {
          _groupedStories[story.userId] = [];
        }
        _groupedStories[story.userId]!.add(story);
        
      
        if (story.id != null) {
          await fetchViewCount(story.id!);
        }
      }
    } catch (e) {
      debugPrint("Error loading stories: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<void> markAsViewed(int storyId, int viewerId) async {
    try {
      await _stroyRepository.markStoryAsViewed(storyId, viewerId);
    
      await fetchViewCount(storyId);
    } catch (e) {
      debugPrint("Error marking view: $e");
    }
  }

  
  Future<void> fetchViewCount(int storyId) async {
    try {
      final count = await _stroyRepository.getStoryViewCount(storyId);
      _storyViewCounts[storyId] = count;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching count: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getViewerList(int storyId) async {
    return await _stroyRepository.getStoryViewers(storyId);
  }

  Future<bool> createStory(StoryDTO storyDTO) async {
    try {
      StoryModel? newStory = await _stroyRepository.createStory(storyDTO);
      if (newStory != null) {
        await getAllStories();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}