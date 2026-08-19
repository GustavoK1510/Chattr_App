import 'package:chattr/components/my_textfield.dart';
import 'package:chattr/services/auth/auth_service.dart';
import 'package:chattr/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("S E T T I N G S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark Mode"),

                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                )
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                TextButton(
                  onPressed: () => _showDeleteDialog(context),
                  style: TextButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    )
                  ),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showDeleteDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("You're about to delete your account. This action is irreversible."),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              )
            ],
          ),
          actions: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: ()  async {
                  if (passwordController.text.trim().isEmpty) {
                    return;
                  }
                  try {
                    await AuthService().deleteUser(passwordController.text);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  e.toString()
                              )
                          )
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => {
                  Navigator.pop(context)
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
          ],
        );
      },
    );
  }
}
