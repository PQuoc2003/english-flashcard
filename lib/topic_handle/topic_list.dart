import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/repository/topic_repo.dart';
import 'package:english_flashcard/topic_handle/topic_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicListPage extends StatefulWidget {
  final int mode;
  final String folderId;
  final FolderModel? folderModel;

  const TopicListPage({
    super.key,
    required this.mode,
    required this.folderId,
    this.folderModel,
  });

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  final TopicRepository topicRepository = TopicRepository();

  final _key = GlobalKey<FormState>();
  final _cltTitleTopic = TextEditingController();
  final _cltDescriptionTopic = TextEditingController();

  @override
  void dispose() {
    _cltTitleTopic.dispose();
    _cltDescriptionTopic.dispose();
    super.dispose();
  }

  Widget listItems(
      BuildContext context, int index, TopicModel topicModel, String topicId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(CupertinoIcons.book),
        ),
        title: Text(topicModel.topicName),
        subtitle: Text("Words: ${topicModel.numberOfWord}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailsPage(
                topicModel: topicModel,
              ),
            ),
          );
        },
        trailing: IconButton(
          icon: const Icon(CupertinoIcons.trash),
          onPressed: () {
            topicRepository.deleteTopic(context, topicId);
          },
        ),
      ),
    );
  }

  Future<void> _createTopic() async {
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          // Add Material widget here
          child: CupertinoAlertDialog(
            title: const Text('Create New Topic'),
            content: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _cltTitleTopic,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      icon: Icon(CupertinoIcons.textformat),
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
                      icon: Icon(CupertinoIcons.textformat_size),
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
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  final navigator = Navigator.of(context);

                  if (_key.currentState?.validate() ?? false) {
                    setState(() {});

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
                      uid: user?.uid ?? "1",
                      currLearningIndex: currLearningIndex,
                      numberOfWord: numberOfWord,
                    );

                    await topicRepository.createTopic(context, topicModel);

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
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _topicBox(int mode) {
    final user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: mode == 0
            ? topicRepository.getTopicByUserId(user?.uid ?? "1")
            : topicRepository.getTopicByFolderId(widget.folderId),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          List topicList = snapshots.data?.docs ?? [];
          if (topicList.isEmpty) {
            return const Center(
              child: Text("No topics"),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: widget.folderModel != null
            ? Text("${widget.folderModel?.folderName}")
            : const Text("Topic List"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _createTopic,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _topicBox(widget.mode),
            ],
          ),
        ),
      ),
    );
  }
}
