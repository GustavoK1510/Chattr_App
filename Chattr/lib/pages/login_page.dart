import 'dart:async';

import 'package:chattr/auth/auth_service.dart';
import 'package:chattr/components/my_button.dart';
import 'package:chattr/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;


  LoginPage({
    super.key,
    required this.onTap,
  });

  void login(BuildContext context) async {
    final AuthService authService = AuthService();

    try {
      await authService.signInWithEmailPassword(_emailController.text, _pwController.text);
    } catch (e) {
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 50),

              Text("Welcome back, we've missed you!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              MyTextField(
                obscureText: false,
                controller: _emailController,
                hintText: "Email",
              ),

              const SizedBox(height: 10),

              MyTextField(
                obscureText: true,
                controller: _pwController,
                hintText: "Password",
              ),

              const SizedBox(height: 10),

              MyButton(
                text: "Login",
                onTap: () => login(context),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member yet? ",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
