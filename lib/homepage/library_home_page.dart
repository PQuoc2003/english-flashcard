import 'package:english_flashcard/folder_handle/folder_list.dart';
import 'package:english_flashcard/topic_handle/topic_list.dart';
import 'package:flutter/material.dart';

class LibraryHomePage extends StatefulWidget {
  const LibraryHomePage({super.key});

  @override
  LibraryHomePageState createState() => LibraryHomePageState();
}

class LibraryHomePageState extends State<LibraryHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Settings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Topic'),
              Tab(text: 'Folder'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TopicListPage(mode: 0, folderId: "no"),
            FolderListPage(),
          ],
        ),
      ),
    );
  }
}
