import 'package:chattr/components/tabs/search_tab.dart';
import 'package:flutter/material.dart';

class AddUsersPage extends StatelessWidget {
  const AddUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("A D D  F R I E N D S"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Search"),
              Tab(text: "Received"),
              Tab(text: "Sent"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SearchTab(),
            //ReceivedTab(),
            //SentTab(),
          ],
        ),
      ),
    );
  }
}
