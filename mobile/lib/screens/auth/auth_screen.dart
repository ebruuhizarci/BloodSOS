import 'package:flutter/material.dart';
import 'package:blood_sos/screens/auth/login_screen.dart';
import 'package:blood_sos/screens/auth/register_screen.dart';

enum AuthScreenPage { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthScreenPage currentPage = AuthScreenPage.login;

  void togglePage() {
    setState(() {
      currentPage = currentPage == AuthScreenPage.login
          ? AuthScreenPage.register
          : AuthScreenPage.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentPage == AuthScreenPage.login
            ? LoginScreen(togglePage: togglePage)
            : RegisterScreen(togglePage: togglePage),
      ),
    );
  }
}
