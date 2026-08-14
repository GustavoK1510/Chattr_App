import 'package:chattr/components/my_friend_request_tile.dart';
import 'package:chattr/services/friends/friend_service.dart';
import 'package:flutter/material.dart';

class SentTab extends StatefulWidget {
  const SentTab({super.key});

  @override
  State<SentTab> createState() => _SentTabState();
}

class _SentTabState extends State<SentTab> {
  final _friendService = FriendService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _friendService.getSentRequests(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No sent requests"),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final request = snapshot.data!.docs[index];
            final data = request.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyFriendRequestTile(
                email: data["receiverEmail"],
                actions: Text("Already sent!"),
              ),
            );

          },

        );
      },
    );
  }
}
