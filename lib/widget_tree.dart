import 'package:english_flashcard/login_page.dart';
import 'package:flutter/material.dart';

import 'account/change_password.dart';
import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
      builder: (context, snapshot) {
          if(snapshot.hasData){
            // return HomePage();
            return const ChangePasswordPage();
          }
          return const LoginPage();
          // return const ChangePasswordPage();
      },
    );
  }
}
