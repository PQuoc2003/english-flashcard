import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:english_flashcard/repository/word_repo.dart';
import 'package:flutter/material.dart';

class TopicDetailsPage extends StatefulWidget {
  final String topicId;
  final TopicModel topicModel;

  const TopicDetailsPage({
    super.key,
    required this.topicId,
    required this.topicModel,
  });

  @override
  State<TopicDetailsPage> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  final WordRepository wordRepository = WordRepository();

  Widget listItems(
      BuildContext context, int index, WordModel wordModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: Text(index.toString()),
        title: Text(wordModel.english),
        subtitle: Text(wordModel.vietnamese),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Topic ID: $index'),
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

  Widget _topicBox(String topicId, TopicModel topicModel) {

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: wordRepository.getWordByTopicId(topicId),
        builder: (context, snapshots) {
          List wordList = snapshots.data?.docs ?? [];
          if (wordList.isEmpty) {
            return const Center(
              child: Text("No word"),
            );
          }
          return ListView.builder(
            itemCount: wordList.length,
            itemBuilder: (context, index) {
              WordModel wordModel = wordList[index].data();
              // String docId = wordList[index].id;
              return listItems(context, index, wordModel);
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
            _topicBox(widget.topicId, widget.topicModel),
          ],
        ),
      ),
    );
  }
}
