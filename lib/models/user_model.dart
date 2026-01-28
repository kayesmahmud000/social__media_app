class User {
  final int? id;
  final String email;
  final String pass;
  final String userName;
  final String? profileUrl;

  User({
    this.id,
    required this.email,
    required this.pass,
    required this.userName,
    this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': userName,
      'email': email,
      'password': pass,
      'profile_url': profileUrl,
    };
  }

 factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      email: data['email'],
      pass: data['password'],
      userName: data['username'],
      profileUrl: data['profile_url']
    );
  }
}
