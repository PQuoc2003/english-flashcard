import 'package:english_flashcard/account/user_setting.dart';
import 'package:english_flashcard/homepage/library_home_page.dart';
import 'package:english_flashcard/homepage/search_homepage.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currIndex = 0;

  List<Widget> widgetList = const [
    SearchHomepage(),
    LibraryHomePage(),
    UserSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            _currIndex = idx;
          });
        },
        currentIndex: _currIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
