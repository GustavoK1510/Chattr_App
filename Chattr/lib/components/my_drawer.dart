import 'package:chattr/pages/addUsers_page.dart';
import 'package:chattr/pages/settings_page.dart';
import 'package:chattr/services/auth/auth_service.dart';
import 'package:chattr/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  )
                )
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "A D D  F R I E N D S",
                    style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  leading: const Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUsersPage()));
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),


        ],
      ),
    );
  }
}
