import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/repository/topic_repo.dart';
import 'package:english_flashcard/topic_handle/topic_details.dart';
import 'package:flutter/material.dart';

class TopicListPage extends StatefulWidget {
  final int mode;
  final String folderId;

  const TopicListPage({
    super.key,
    required this.mode,
    required this.folderId,
  });

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  final TopicRepository topicRepository = TopicRepository();

  final _key = GlobalKey<FormState>();
  final _cltTitleTopic = TextEditingController();
  final _cltDescriptionTopic = TextEditingController();

  final uid = "1";

  @override
  void dispose() {
    _cltTitleTopic.dispose();
    _cltDescriptionTopic.dispose();
    super.dispose();
  }

  Widget listItems(
    BuildContext context,
    int index,
    TopicModel topicModel,
    String topicId,
  ) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailsPage(
                topicModel: topicModel,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topicBox(int mode) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: mode == 0
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Create new Topic'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        if (_key.currentState?.validate() ?? false) {
                          String topicName = _cltTitleTopic.text.toString();
                          String topicDescription =
                              _cltDescriptionTopic.text.toString();
                          Timestamp createdDate = Timestamp.now();
                          String folderId = widget.folderId;
                          int currLearningIndex = 0;
                          int numberOfWord = 0;

                          TopicModel topicModel = TopicModel(
                            topicName: topicName,
                            topicDescription: topicDescription,
                            createdDate: createdDate,
                            folderId: folderId,
                            uid: uid,
                            currLearningIndex: currLearningIndex,
                            numberOfWord: numberOfWord,
                          );

                          topicRepository.createTopic(context, topicModel);

                          navigator.pop();

                          navigator.push(
                            MaterialPageRoute(
                              builder: (context) => TopicDetailsPage(
                                topicModel: topicModel,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'))
                ],
                content: AlertDialog(
                  title: const Text('Add Form'),
                  content: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _cltTitleTopic,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _cltDescriptionTopic,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
