import 'package:social_media_app/services/user__service.dart';

class StoryService {
  static const TABLE_STORY = 'stories';
  static const COL_STORY_ID = 'id';
  static const COL_STORY_USER_ID = 'user_id';
  static const COL_STORY_MEDIA_URL = 'media_url';
  static const COL_STORY_CAPTION = 'caption';
  static const COL_STORY_TIME_STAMP = 'time_stamp';

  static const TABLE_VIEWS = 'views';
  static const COL_VIEW_ID = 'id';
  static const COL_VIEWER_ID = 'viewer_id';
  static const COL_VIEWS_STORY_ID = 'story_id';
  static const COL_VIEWS_TIME = 'views_time';

 
  static const String createTable =
      '''
CREATE TABLE $TABLE_STORY (
$COL_STORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,
$COL_STORY_MEDIA_URL TEXT,
$COL_STORY_USER_ID INTEGER NOT NULL,
$COL_STORY_CAPTION TEXT,
$COL_STORY_TIME_STAMP TEXT,
FOREIGN KEY ($COL_STORY_USER_ID) REFERENCES ${UserService.TABLE_USER} (${UserService.COL_USER_ID}) ON DELETE CASCADE
)
''';

  static const String createViewsTable =
      '''
CREATE TABLE $TABLE_VIEWS (
$COL_VIEW_ID INTEGER PRIMARY KEY AUTOINCREMENT,
$COL_VIEWS_STORY_ID INTEGER NOT NULL,
$COL_VIEWER_ID INTEGER NOT NULL,
$COL_VIEWS_TIME TEXT,
FOREIGN KEY ($COL_VIEWS_STORY_ID) REFERENCES $TABLE_STORY ($COL_STORY_ID) ON DELETE CASCADE,
FOREIGN KEY ($COL_VIEWER_ID) REFERENCES ${UserService.TABLE_USER} (${UserService.COL_USER_ID}) ON DELETE CASCADE,
UNIQUE($COL_VIEWS_STORY_ID, $COL_VIEWER_ID)
)
''';

  static String selectActiveStoriesWithUser(String timeLimit) {
    return '''
      SELECT 
        s.*, 
        u.${UserService.COL_USER_NAME} AS username, 
        u.${UserService.COL_USER_PROFILE_PIC_URL} AS profile_url
      FROM $TABLE_STORY s
      INNER JOIN ${UserService.TABLE_USER} u 
        on s.$COL_STORY_USER_ID = u.${UserService.COL_USER_ID}
      WHERE s.$COL_STORY_TIME_STAMP > '$timeLimit'
      ORDER BY s.$COL_STORY_TIME_STAMP ASC
    ''';
  }

  static String selectStoryViewers(int storyId) {
    return '''
      SELECT 
        u.${UserService.COL_USER_NAME},  
        u.${UserService.COL_USER_PROFILE_PIC_URL},
        v.$COL_VIEWS_TIME
      FROM $TABLE_VIEWS v
      INNER JOIN ${UserService.TABLE_USER} u 
        ON v.$COL_VIEWER_ID = u.${UserService.COL_USER_ID}
      WHERE v.$COL_VIEWS_STORY_ID = $storyId
      ORDER BY v.$COL_VIEWS_TIME DESC
    ''';
  }
}
