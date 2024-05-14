import 'dart:async';
import 'package:flutter/material.dart';
import 'package:english_flashcard/models/word_model.dart';

class FlashcardScreen extends StatefulWidget {
  final List<WordModel> wordList;

  const FlashcardScreen({Key? key, required this.wordList}) : super(key: key);

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  bool showFront = true;
  bool autoPronunciation = true;
  bool showStarredOnly = false;
  bool autoMode = false;
  List<WordModel> displayList = [];
  Timer? autoModeTimer;
  Timer? pronunciationDebounceTimer;

  @override
  void initState() {
    super.initState();
    displayList = widget.wordList;
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  @override
  void dispose() {
    autoModeTimer?.cancel();
    pronunciationDebounceTimer?.cancel();
    super.dispose();
  }

  void playPronunciation() {
    pronunciationDebounceTimer?.cancel();
    pronunciationDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Implement your text-to-speech or audio play logic here
      print("Playing pronunciation: ${displayList[currentIndex].english}");
    });
  }

  void flipCard() {
    setState(() {
      showFront = !showFront;
    });
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % displayList.length;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  void previousCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + displayList.length) % displayList.length;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  void toggleStarred() {
    setState(() {
      showStarredOnly = !showStarredOnly;
      displayList = showStarredOnly
          ? widget.wordList.where((word) => word.isLearned).toList()
          : widget.wordList;
      currentIndex = 0;
      showFront = true;
    });
  }

  void shuffleWords() {
    setState(() {
      displayList.shuffle();
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
    if (displayList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flashcards'),
        ),
        body: const Center(
          child: Text('No words available.'),
        ),
      );
    }

    final currentWord = displayList[currentIndex];

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
              'Word ${currentIndex + 1} / ${displayList.length}',
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
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show only learned words'),
                Switch(
                  value: showStarredOnly,
                  onChanged: (value) => toggleStarred(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
