import 'package:flutter/material.dart';

class AddUsersPage extends StatelessWidget {
  const AddUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("A D D  F R I E N D S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
    );
  }
}
