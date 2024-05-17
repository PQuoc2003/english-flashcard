import 'package:english_flashcard/models/topic_model.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:english_flashcard/quiz/quiz_screen.dart';
import 'package:english_flashcard/repository/topic_repo.dart';
import 'package:english_flashcard/repository/word_repo.dart';
import 'package:english_flashcard/word_typing/typing_practice_screen.dart';
import 'package:english_flashcard/flash_card/flash_card_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

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

  void importWordsFromCSV(BuildContext context, String topicId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      // Extract file path
      String? filePath = result.files.single.path;

      if (filePath != null) {
        // Read CSV file
        File file = File(filePath);
        String csvContent = await file.readAsString();

        // Parse CSV content
        List<List<dynamic>> csvList =
            const CsvToListConverter().convert(csvContent);

        // Iterate through CSV rows and add words to repository
        for (var csvRow in csvList) {
          String english = csvRow[0].toString();
          String vietnamese = csvRow[1].toString();

          WordModel wordModel = WordModel(
            english: english,
            vietnamese: vietnamese,
            isLearned: false,
            topicId: topicId,
          );

          // Save the word to the repository
          wordRepository.addWord(context, wordModel);
        }
      }
    } else {
      // User canceled the file picker
    }
  }

  Widget _navigationButtons() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: CupertinoButton(
                  onPressed: () {
                    if (wordList.length < 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Need at least 2 words to start a quiz"),
                        ),
                      );
                      return;
                    }
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
                  color: Colors.blue,
                  child: const Text("Quiz now"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: CupertinoButton(
                  onPressed: () {
                    if (wordList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("No words available for typing practice"),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TypingPracticeScreen(
                          topicId: topicId,
                          wordList: wordList,
                        ),
                      ),
                    );
                  },
                  color: Colors.blue,
                  child: const Text("Typing Practice"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: CupertinoButton(
                  onPressed: () {
                    if (wordList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No words available for flashcards"),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlashcardScreen(
                          wordList: wordList,
                        ),
                      ),
                    );
                  },
                  color: Colors.blue,
                  child: const Text("Flashcards"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.topicModel.topicName),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _navigationButtons(),
              _topicBox(topicId),
            ],
          ),
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
                      child: const Text('Add')),
                  TextButton(
                    onPressed: () {
                      importWordsFromCSV(context, topicId);
                    },
                    child: const Text('Import from CSV'),
                  ),
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
