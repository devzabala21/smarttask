import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../models/user_model.dart';
import 'label_service.dart';

class AuthService {
  static final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> avatarOptions = [
    'assets/img/img_icon_01-240x.png',
    'assets/img/img_icon_02-200x.png',
  ];

  static User? currentUser;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static String avatarAssetForIndex(int index) {
    switch (index) {
      case 0:
        return 'assets/img/img_icon_01-240x.png';
      case 1:
        return 'assets/img/img_icon_02-200x.png';
      default:
        return avatarOptions.first;
    }
  }

  static int avatarIndexForPath(String path) {
    switch (path) {
      case 'assets/img/img_icon_01-240x.png':
        return 0;
      case 'assets/img/img_icon_02-200x.png':
        return 1;
      default:
        return 0;
    }
  }

  static Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required String contactNumber,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) return false;

      final user = User(
        uid: uid,
        username: username,
        email: email,
        bio: 'My Tasks',
        iconIndex: 0,
        contactNumber: contactNumber,
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());
      currentUser = user;
      await LabelService.loadLabelsForUser(uid);
      return true;
    } on fb_auth.FirebaseAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) return false;

      return await _loadCurrentUser(uid);
    } on fb_auth.FirebaseAuthException {
      return false;
    }
  }

  static Future<bool> _loadCurrentUser(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return false;

    final data = snapshot.data()!;
    final email = data['email'] as String? ?? _auth.currentUser?.email ?? '';
    currentUser = User.fromMap(uid, data, email: email);
    await LabelService.loadLabelsForUser(uid);
    return true;
  }

  static Future<bool> updateProfile({
    required String username,
    required String bio,
    required int iconIndex,
  }) async {
    final current = currentUser;
    if (current == null) return false;

    final updatedUser = current.copyWith(
      username: username,
      bio: bio,
      iconIndex: iconIndex,
    );

    await _firestore
        .collection('users')
        .doc(current.uid)
        .update(updatedUser.toMap());

    currentUser = updatedUser;
    return true;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
  }
}
