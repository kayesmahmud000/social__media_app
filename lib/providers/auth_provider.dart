import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/helper/security_helper.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/repositories/user_repository.dart';
import 'package:social_media_app/usecases/user_login_use_case.dart';
import 'package:social_media_app/usecases/user_sign_up_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;

  bool _isLoggedIn = false;
  bool _isLoading =false;

  bool get isLoading => _isLoading;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signUp(UserSignUpDTO userDTO) async {
    _setLoading(true);

    try {
      User? user = await _userRepository.signUp(userDTO);

    if (user !=null) {
      _currentUser = user;
      _isLoggedIn = true;

      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setInt('userId', user.id!);

      notifyListeners();
      return true;
    }
    return false;
    } catch (e) {
      debugPrint(e.toString());
     rethrow;
    }finally {
      _setLoading(false); 
    }
  }

  Future<bool> login(UserLoginDTO userDTO) async {
    

    User? user = await _userRepository.login(userDTO);

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
