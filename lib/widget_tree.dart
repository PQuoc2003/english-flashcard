import 'package:flutter/material.dart';
import 'package:english_flashcard/login_page.dart';
import 'package:english_flashcard/home_page.dart';
import 'package:english_flashcard/topic_screen.dart';
import 'package:english_flashcard/auth.dart';
import 'package:english_flashcard/user_setting.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          // User is logged in, show HomePage layout
          return HomePage(); // You may want to pass additional parameters here if required
        } else {
          // User is not logged in, show LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
