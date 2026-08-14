import 'package:flutter/material.dart';

class MyFriendRequestTile extends StatelessWidget {
  final String email;
  final Widget actions;
  const MyFriendRequestTile({
    super.key,
    required this.email,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(email),
        trailing: actions,
      ),
    );
  }
}
