class User {
  final String username;
  final String email;
  final String password;
  final String bio;
  final String avatarPath;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.bio = 'My Tasks',
    this.avatarPath = 'assets/img/img_icon_01-240x.png',
  });

  User copyWith({
    String? username,
    String? email,
    String? password,
    String? bio,
    String? avatarPath,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}