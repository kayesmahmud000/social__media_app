class UserUpdateDTO {
  final int id;
   final String? username;
  final String? profileUrl;

  const UserUpdateDTO({required this.id, this.username,   this.profileUrl});
}