import 'package:flutter/material.dart';

import 'models/topic.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics')),
      body: const Center(
        child: Text('List of topics'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to screen to create a new topic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// folder_screen.dart
class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: const Center(
        child: Text('List of folders'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to screen to create a new folder
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// topic_details_screen.dart
class TopicDetailsScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailsScreen(this.topic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.name)),
      body: const Center(
        child: Text('Details of the topic'),
      ),
    );
  }
}

// folder_details_screen.dart
class FolderDetailsScreen extends StatelessWidget {
  final Folder folder;

  const FolderDetailsScreen(this.folder, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folder.name)),
      body: const Center(
        child: Text('Details of the folder'),
      ),
    );
  }
}
