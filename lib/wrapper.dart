import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'wellness.dart';
import 'login_signup.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return WellnessPage(); // ✅ use correct class name from home_page.dart
        } else {
          return const LoginPage(); // ✅ use correct class name from login_signup.dart
        }
      },
    );
  }
}
