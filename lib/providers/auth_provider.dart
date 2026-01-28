import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/helper/security_helper.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;

  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> signUp(String userName, String email, String pass) async {
    String hashedPass = SecurityHelper.hashedPassword(pass);

    User newUser = User(userName: userName, email: email, pass: hashedPass);

    int userId = await _userRepository.signUp(newUser);

    if (userId > 0) {
      _currentUser = User(
        id: userId,
        userName: userName,
        email: email,
        pass: hashedPass,
      );
      _isLoggedIn = true;

      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setInt('userId', userId);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String pass) async {
    String hashedPass = SecurityHelper.hashedPassword(pass);

    User? user = await _userRepository.login(email, hashedPass);

    if (user != null) {
      _currentUser = user;
      _isLoggedIn = true;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setInt('userId', user.id!);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> checkLoginStatus() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    int? userId = sharedPreferences.getInt('userId');

    if (userId != null) {
      _currentUser = await _userRepository.getUserById(userId);
      if (_currentUser != null) {
        _isLoggedIn = true;
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userId');
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
