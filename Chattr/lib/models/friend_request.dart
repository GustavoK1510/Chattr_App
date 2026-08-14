import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {
  pending,
  accepted,
  declined,
}

class FriendRequest {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String receiverEmail;
  final Status status;
  final Timestamp timestamp;

  FriendRequest({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.receiverEmail,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'receiverEmail': receiverEmail,
      'status': status.name,
      'timestamp': timestamp,
    };
  }
}