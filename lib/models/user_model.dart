class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final int iconIndex;
  final String contactNumber;

  User({
    required this.uid,
    required this.username,
    required this.email,
    this.bio = 'My Tasks',
    this.iconIndex = 0,
    this.contactNumber = '',
  });

  User copyWith({
    String? uid,
    String? username,
    String? email,
    String? bio,
    int? iconIndex,
    String? contactNumber,
  }) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      iconIndex: iconIndex ?? this.iconIndex,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }

  factory User.fromMap(
    String uid,
    Map<String, dynamic> data, {
    required String email,
  }) {
    return User(
      uid: uid,
      username: data['username'] as String? ?? '',
      email: email,
      bio: data['bio'] as String? ?? 'My Tasks',
      iconIndex: data['icon_index'] as int? ?? 0,
      contactNumber: data['contact_number'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'bio': bio,
      'email': email,
      'icon_index': iconIndex,
      'contact_number': contactNumber,
    };
  }
}
