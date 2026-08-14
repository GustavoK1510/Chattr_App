import 'package:chattr/models/friend_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Search a user by email
  Future<QuerySnapshot> searchUserEmail(String email) async {
    return await _firestore
        .collection("Users")
        .where("email", isEqualTo: email)
        .where("email", isNotEqualTo: _auth.currentUser!.email!)
        .get();
  }

  // Send a friend request
  Future<void> sendFriendRequest(String receiverID, receiverEmail) async {

    // Create a new request
    FriendRequest newFriendRequest = FriendRequest(
        senderID: _auth.currentUser!.uid,
        senderEmail: _auth.currentUser!.email!,
        receiverID: receiverID,
        receiverEmail: receiverEmail,
        status: Status.pending,
        timestamp: Timestamp.now(),
    );

    // Add to firestore
    await _firestore
      .collection("friend_requests")
      .add(newFriendRequest.toMap());
  }

  // Check for pending requests
  Future<bool> hasPendingRequest(String receiverID) async {

    // Query to see if there are requests each way or already friends
    final results = await Future.wait([
      _firestore
          .collection("friend_requests")
          .where("senderID", isEqualTo: _auth.currentUser!.uid)
          .where("receiverID", isEqualTo: receiverID)
          .where("status", isEqualTo: Status.pending.name)
          .get(),
      _firestore
          .collection("friend_requests")
          .where("senderID", isEqualTo: receiverID)
          .where("receiverID", isEqualTo: _auth.currentUser!.uid)
          .where("status", isEqualTo: Status.pending.name)
          .get(),
      _firestore
          .collection("friends")
          .where("users", arrayContains: _auth.currentUser!.uid)
          .get(),
    ]);

    // Verify them
     return results.any((result) => result.docs.isNotEmpty);
  }

  // Get sent requests
  Stream<QuerySnapshot> getSentRequests() {
    return _firestore
        .collection("friend_requests")
        .where("senderID", isEqualTo: _auth.currentUser!.uid)
        .where("status", isEqualTo: Status.pending.name)
        .snapshots();
  }

  // Get received requests
  Stream<QuerySnapshot> getReceivedRequests() {
    return _firestore
        .collection("friend_requests")
        .where("receiverID", isEqualTo: _auth.currentUser!.uid)
        .where("status", isEqualTo: Status.pending.name)
        .snapshots();
  }

  // Accept a request
  Future<void> acceptFriendRequest(String requestID) async {
    final request = await _firestore
        .collection("friend_requests")
        .doc(requestID)
        .get();

    final String senderID = request.data()?["senderID"];
    final String userID = _auth.currentUser!.uid;

    final List<String> ids = [senderID, userID];
    ids.sort();
    final String friendshipID = ids.join("_");

    await _firestore
        .collection("friends")
        .doc(friendshipID)
        .set({
          "users": ids,
          "createdAt": Timestamp.now(),
        });
    
    await _firestore
        .collection("friend_requests")
        .doc(requestID)
        .update({
          "status": Status.accepted.name,
        });
  }

  // Decline a request
  Future<void> declineFriendRequest(String requestID) async {
    await _firestore
        .collection("friend_requests")
        .doc(requestID)
        .update({
          "status": Status.declined.name,
        });
  }

  // Get all of User's friends
  Stream<QuerySnapshot> getFriends() {
    return _firestore
        .collection("friends")
        .where("users", arrayContains: _auth.currentUser!.uid)
        .snapshots();
  }

  // Get a specific User
  Future<DocumentSnapshot> getUserById(String uid) {
    return _firestore
        .collection("Users")
        .doc(uid)
        .get();
  }

  // Get the user information from a friend
  Stream<List<Map<String, dynamic>>> getFriendUsers() {

    // Listen to the friend collection
    return _firestore
        .collection("friends")
        .where("users", arrayContains: _auth.currentUser!.uid)
        .snapshots()
        .asyncMap((snapshot) async { // Convert each friendship into a User
      final List<Map<String, dynamic>> friends = [];

      // Loop through the friendships
      for (final doc in snapshot.docs) {
        final users = List<String>.from(doc["users"]);

        // Remove the User's UID
        final friendUID = users.firstWhere(
              (id) => id != _auth.currentUser!.uid,
        );

        // Load the friend's User document
        final userDoc = await _firestore
            .collection("Users")
            .doc(friendUID)
            .get();

        // Add it to the list
        if (userDoc.exists) {
          friends.add(userDoc.data()!);
        }
      }

      // Return the list
      return friends;
    });
  }
}