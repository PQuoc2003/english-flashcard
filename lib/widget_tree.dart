import 'package:english_flashcard/homepage/main_home_page.dart';
import 'package:english_flashcard/account/login_page.dart';
import 'package:flutter/material.dart';

import 'account/auth.dart';

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
            // return const UserHomePage();
            return const MainHomePage();
          }
          return const LoginPage();
        // return const MainHomePage();
        // return const TopicListPage(mode: 0, folderId: "no");
        // return const UserHomePage();
      },


    );
  }
}
