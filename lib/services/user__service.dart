class UserService{
  
  // user table
  static const TABLE_USER = 'users';
  static const COL_USER_ID = 'id';
  static const COL_USER_NAME = 'username';
  static const COL_USER_PASS = 'password';
  static const COL_USER_EMAIL = 'email';
  static const COL_USER_PROFILE_PIC_URL = 'profile_url';

  static const String createTable = '''
      CREATE TABLE $TABLE_USER (
        $COL_USER_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COL_USER_NAME TEXT NOT NULL, 
        $COL_USER_EMAIL TEXT UNIQUE NOT NULL, 
        $COL_USER_PASS TEXT NOT NULL, 
        $COL_USER_PROFILE_PIC_URL TEXT
      )
    ''';
}