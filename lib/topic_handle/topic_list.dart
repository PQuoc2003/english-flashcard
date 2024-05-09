import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/repository/topic_repo.dart';
import 'package:flutter/material.dart';

class TopicListPage extends StatefulWidget {
  final int mode;

  const TopicListPage({super.key, required this.mode});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  final TopicRepository topicRepository = TopicRepository();

  Widget listItems(
      BuildContext context, int index, TopicModel topicModel, String topicId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: Text(index.toString()),
        title: Text(topicModel.topicName),
        subtitle: Text(topicModel.numberOfWord.toString()),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Topic ID: $topicId'),
            ),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AnotherClass(topicId)),
          // );
        },
      ),
    );
  }

  Widget _topicBox(int mode) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: mode == 1
            ? topicRepository.getTopicByUserId("1")
            : topicRepository.getTopicByFolderId("2"),
        builder: (context, snapshots) {
          List topicList = snapshots.data?.docs ?? [];
          if (topicList.isEmpty) {
            return const Center(
              child: Text("No topic"),
            );
          }
          return ListView.builder(
            itemCount: topicList.length,
            itemBuilder: (context, index) {
              TopicModel topicModel = topicList[index].data();
              String docId = topicList[index].id;
              return listItems(context, index, topicModel, docId);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topicBox(widget.mode),
          ],
        ),
      ),
    );
  }
}
