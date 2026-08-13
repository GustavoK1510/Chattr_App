import 'package:chattr/components/my_button.dart';
import 'package:chattr/components/my_textfield.dart';
import 'package:chattr/services/friends/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _searchController = TextEditingController();
  final _friendService = FriendService();
  DocumentSnapshot? _foundUser;
  bool _requestSent = false;

  void changeText() {

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: MyTextField(
            hintText: "Email",
            controller: _searchController,
            obscureText: false,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: MyButton(
            text: "Search",
            onTap: () async {
              final result = await _friendService.searchUserEmail(
                  _searchController.text);

              if (result.docs.isEmpty) {
                setState(() {
                  _foundUser = null;
                  _requestSent = false;
                });
              } else {
                final user = result.docs.first;

                final requestSent = await _friendService.hasPendingRequest(
                  user["uid"],
                );

                setState(() {
                  _foundUser = user;
                  _requestSent = requestSent;
                });
              }
            },
          ),
        ),
        const SizedBox(height: 20),

        if (_foundUser != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                _foundUser!["email"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(_requestSent ? "Add this user as a friend!" : "Already requested!"),

              trailing: ElevatedButton(
                onPressed: _requestSent ? null : () async {
                  await _friendService.sendFriendRequest(_foundUser!["uid"], _foundUser!["email"]);

                  setState(() {
                    _requestSent = true;
                  });
                },
                child: Text(
                    _requestSent ? "Add Friend" : "Requested"),
              ),
            ),
          ),
      ],

    );
  }
}
