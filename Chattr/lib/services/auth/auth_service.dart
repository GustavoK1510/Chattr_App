import 'package:chattr/services/friends/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _friendService = FriendService();

  // Get the current user data
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in using Email and Password verification
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    }
  }

  // Register a new User data
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Delete the logged in User
  Future<void> deleteUser(String password) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("No authenticated user.");
      }

      // Create an AuthCredential with the user data
      final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password
      );

      // Reauthenticate the user
      await user.reauthenticateWithCredential(credential);

      // Delete the user's friendships and friend requests
      await _friendService.deleteUserFriendData();

      // Delete the user's Firestore document
      await _firestore.collection("Users").doc(user.uid).delete();

      // Delete the Firebase Authentication account
      await user.delete();

      // Sign the user out to guarantee a state change
      await _auth.signOut();

    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
