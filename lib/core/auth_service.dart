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

  static Future<bool> updateContactNumber(String contactNumber) async {
    final current = currentUser;
    if (current == null) return false;

    final updatedUser = current.copyWith(contactNumber: contactNumber);

    await _firestore
        .collection('users')
        .doc(current.uid)
        .update({'contact_number': contactNumber});

    currentUser = updatedUser;
    return true;
  }

  static Future<bool> updateEmail(String newEmail, String currentPassword) async {
    try {
      final fb_auth.User? user = _auth.currentUser;
      if (user == null || currentUser == null) return false;

      // Re-authenticate user before email change
      final credential = fb_auth.EmailAuthProvider.credential(
        email: currentUser!.email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update email in Firebase Auth
      await (user as dynamic).updateEmail(newEmail);

      // Update email in Firestore
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update({'email': newEmail});

      currentUser = currentUser!.copyWith(email: newEmail);
      return true;
    } on fb_auth.FirebaseAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> updatePassword(String newPassword, String currentPassword) async {
    try {
      final fb_auth.User? user = _auth.currentUser;
      if (user == null || currentUser == null) return false;

      // Re-authenticate user before password change
      final credential = fb_auth.EmailAuthProvider.credential(
        email: currentUser!.email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password in Firebase Auth
      await (user as dynamic).updatePassword(newPassword);
      return true;
    } on fb_auth.FirebaseAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteAccount(String currentPassword) async {
    try {
      final fb_auth.User? user = _auth.currentUser;
      if (user == null || currentUser == null) return false;

      // Re-authenticate user before account deletion
      final credential = fb_auth.EmailAuthProvider.credential(
        email: currentUser!.email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      final uid = currentUser!.uid;

      // Delete all user data from Firestore
      final batch = _firestore.batch();

      // Delete tasks
      final tasksQuery = await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .get();
      for (final doc in tasksQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete labels
      final labelsQuery = await _firestore
          .collection('users')
          .doc(uid)
          .collection('labels')
          .get();
      for (final doc in labelsQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete user document
      batch.delete(_firestore.collection('users').doc(uid));

      await batch.commit();

      // Delete user from Firebase Auth
      await (user as dynamic).delete();

      currentUser = null;
      return true;
    } on fb_auth.FirebaseAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
  }
}
