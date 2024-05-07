import 'package:english_flashcard/folder_handle/folder_list.dart';
import 'package:english_flashcard/homepage/user_list.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currIndex = 0;

  List<Widget> widgetList = const [
    FolderListPage(),
    UserHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Home page"),
        ),
      ),
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
            icon: Icon(Icons.home),
            label: "History",
          ),
        ],
      ),
    );
  }
}
