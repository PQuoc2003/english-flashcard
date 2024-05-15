import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_flashcard/models/word_model.dart';

class FlashcardScreen extends StatefulWidget {

  final List wordList;

  const FlashcardScreen({super.key, required this.wordList});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<WordModel> myWordList = [];
  int currentIndex = 0;
  bool showFront = true;
  bool autoPronunciation = true;
  bool showStarredOnly = false;
  bool autoMode = false;
  Timer? autoModeTimer;
  Timer? pronunciationDebounceTimer;

  @override
  @override
  void initState() {
    super.initState();
    initSequence();
  }

  @override
  void dispose() {
    autoModeTimer?.cancel();
    pronunciationDebounceTimer?.cancel();
    super.dispose();
  }

  void initSequence() {
    initWordList();
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  void initWordList() {

    for (int i = 0; i < widget.wordList.length; i++) {
      WordModel myWord = widget.wordList[i].data();
      myWordList.add(myWord);
    }
    myWordList.shuffle(Random());

  }

  Future<void> playPronunciation() async {
    pronunciationDebounceTimer?.cancel();
    pronunciationDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Implement your text-to-speech or audio play logic here
    });
  }


  void flipCard() {
    setState(() {
      showFront = !showFront;
    });
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % myWordList.length;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  void previousCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + myWordList.length) % myWordList.length;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  // void toggleStarred() {
  //   setState(() {
  //     showStarredOnly = !showStarredOnly;
  //     if (showStarredOnly) {
  //       myWordList = widget.wordList.where((word) => word.isLearned).toList();
  //     } else {
  //       myWordList = List.from(widget.wordList);
  //     }
  //     currentIndex = 0;
  //     showFront = true;
  //   });
  // }

  void shuffleWords() {
    setState(() {
      myWordList.shuffle();
      currentIndex = 0;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  void toggleAutoMode() {
    setState(() {
      autoMode = !autoMode;
      if (autoMode) {
        autoModeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
          nextCard();
        });
      } else {
        autoModeTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (myWordList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flashcards'),
        ),
        body: const Center(
          child: Text('No words available.'),
        ),
      );
    }

    final currentWord = myWordList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Word ${currentIndex + 1} / ${myWordList.length}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: flipCard,
              child: Card(
                child: Container(
                  height: 300.0,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    showFront ? currentWord.vietnamese : currentWord.english,
                    style: const TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: playPronunciation,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: previousCard,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: nextCard,
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: shuffleWords,
                  child: const Text('Shuffle'),
                ),
                ElevatedButton(
                  onPressed: toggleAutoMode,
                  child: Text(autoMode ? 'Stop Auto Mode' : 'Start Auto Mode'),
                ),
              ],
            ),
            // const SizedBox(height: 20.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text('Show only learned words'),
            //     Switch(
            //       value: showStarredOnly,
            //       // onChanged: (value) => toggleStarred(),
            //       onChanged: (value){},
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
