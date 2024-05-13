import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:english_flashcard/quiz/quiz_screen.dart';
import 'package:english_flashcard/repository/topic_repo.dart';
import 'package:english_flashcard/repository/word_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopicDetailsPage extends StatefulWidget {
  final TopicModel topicModel;

  const TopicDetailsPage({
    super.key,
    required this.topicModel,
  });

  @override
  State<TopicDetailsPage> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  final WordRepository wordRepository = WordRepository();
  final TopicRepository topicRepository = TopicRepository();

  final _key = GlobalKey<FormState>();

  final _ctlEnglish = TextEditingController();
  final _ctlVietnamese = TextEditingController();

  String topicId = "";

  List wordList = [];

  @override
  void initState() {
    super.initState();
    fetchTopicId();
  }

  @override
  void dispose() {
    _ctlVietnamese.dispose();
    _ctlEnglish.dispose();
    super.dispose();
  }

  void fetchTopicId() async {
    final user = FirebaseAuth.instance.currentUser;
    String topicId = await topicRepository.getTopicIdByUidAndCreatedDate(
        user?.uid ?? "1", widget.topicModel.createdDate);
    setState(() {
      this.topicId = topicId;
    });
  }

  Widget listItems(BuildContext context, int index, WordModel wordModel) {
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
        },
      ),
    );
  }

  Widget _topicBox(String topicId) {
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
          this.wordList = wordList;
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

  Widget _toQuizScreen() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                topicId: topicId,
                wordList: wordList,
              ),
            ),
          );
        },
        child: const Text(" To word list"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicModel.topicName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _toQuizScreen(),
            _topicBox(topicId),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              _ctlEnglish.clear();
              _ctlVietnamese.clear();
              return AlertDialog(
                title: const Text('Add new word'),
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
                          String english = _ctlEnglish.text.toString();
                          String vietnamese = _ctlVietnamese.text.toString();
                          bool isLearned = false;

                          WordModel wordModel = WordModel(
                              english: english,
                              vietnamese: vietnamese,
                              isLearned: isLearned,
                              topicId: topicId);

                          wordRepository.addWord(context, wordModel);

                          navigator.pop();
                        }
                      },
                      child: const Text('Add'))
                ],
                content: AlertDialog(
                  title: const Text('Add new word'),
                  content: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _ctlEnglish,
                          decoration: const InputDecoration(
                            labelText: 'English',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _ctlVietnamese,
                          decoration: const InputDecoration(
                            labelText: 'Vietnamese',
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
