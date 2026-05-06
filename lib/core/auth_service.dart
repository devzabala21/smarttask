import '../models/user_model.dart';

class AuthService {
  static const List<String> avatarOptions = [
    'assets/img/img_icon_01-240x.png',
    'assets/img/img_icon_02-200x.png',
  ];

  static final List<User> _registeredUsers = [
    User(
      username: 'Admin',
      email: 'test@test.com',
      password: '12345678',
      bio: 'My Tasks',
      avatarPath: 'assets/img/img_icon_01-240x.png',
    ),
  ];

  static User? currentUser;

  // Sign Up Logic
  static bool signUp(String username, String email, String password) {
    if (_registeredUsers.any((u) => u.email == email)) return false;

    _registeredUsers.add(
      User(
        username: username,
        email: email,
        password: password,
      ),
    );
    return true;
  }

  static bool updateProfile({
    required String username,
    required String bio,
    required String avatarPath,
  }) {
    final current = currentUser;
    if (current == null) return false;

    final updatedUser = current.copyWith(
      username: username,
      bio: bio,
      avatarPath: avatarPath,
    );

    final index = _registeredUsers.indexWhere((u) => u.email == current.email);
    if (index < 0) return false;

    _registeredUsers[index] = updatedUser;
    currentUser = updatedUser;
    return true;
  }

  // Login Logic
  static bool login(String email, String password) {
    try {
      final user = _registeredUsers.firstWhere(
        (u) => u.email == email && u.password == password
      );
      currentUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }
}