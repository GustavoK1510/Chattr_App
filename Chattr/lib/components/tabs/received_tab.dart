import 'package:chattr/components/my_friend_request_tile.dart';
import 'package:chattr/services/friends/friend_service.dart';
import 'package:flutter/material.dart';

class ReceivedTab extends StatefulWidget {
  const ReceivedTab({super.key});

  @override
  State<ReceivedTab> createState() => _ReceivedTabState();
}

class _ReceivedTabState extends State<ReceivedTab> {
  final _friendService = FriendService();
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: _friendService.getReceivedRequests(),
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
            child: Text("No received requests"),
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
                email: data["senderEmail"],
                actions: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => {
                       _friendService.acceptFriendRequest(request.id)
                    },
                        icon: const Icon(Icons.check),
                    ),

                    IconButton(
                      onPressed: () => {
                        _friendService.declineFriendRequest(request.id)
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            );

          },

        );
      },
    );
  }
}
