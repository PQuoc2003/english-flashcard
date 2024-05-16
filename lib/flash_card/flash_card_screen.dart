import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardScreen extends StatefulWidget {
  final List wordList;

  const FlashcardScreen({super.key, required this.wordList});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _rotation;

  List<WordModel> myWordList = [];
  int currentIndex = 0;
  bool showFront = true;
  bool autoPronunciation = true;
  bool autoMode = false;
  Timer? autoModeTimer;
  Timer? pronunciationDebounceTimer;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initSequence();
  }

  @override
  void dispose() {
    _flipController.dispose();
    autoModeTimer?.cancel();
    pronunciationDebounceTimer?.cancel();
    super.dispose();
  }

  void initSequence() {
    initWordList();
    if (autoPronunciation) {
      playPronunciation();
    }
    _initTts();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation =
        Tween<double>(begin: 0.0, end: 2*pi).animate(_flipController);

  }

  void _initTts() {
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
  }

  void initWordList() {
    for (int i = 0; i < widget.wordList.length; i++) {
      WordModel myWord = widget.wordList[i].data();
      myWordList.add(myWord);
    }
    myWordList.shuffle(Random());
  }

  void playPronunciation() {
    pronunciationDebounceTimer?.cancel();
    pronunciationDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      flutterTts.speak(showFront ? myWordList[currentIndex].vietnamese : myWordList[currentIndex].english);
    });
  }

  void flipCard() {
    if (_flipController.isAnimating) return;
    if (_flipController.isCompleted || _flipController.isDismissed) {
      _flipController.forward(from: 0.5);
      setState(() {
        showFront = !showFront;
      });
    }

  }

  void nextCard() {
    if (_flipController.isAnimating) return;
    setState(() {
      currentIndex = (currentIndex + 1) % myWordList.length;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }

  }

  void previousCard() {
    if (_flipController.isAnimating) return;
    setState(() {
      currentIndex =
          (currentIndex - 1 + myWordList.length) % myWordList.length;
      showFront = true;
    });
    if (autoPronunciation) {
      playPronunciation();
    }
  }

  void shuffleWords() {
    if (_flipController.isAnimating) return;
    _flipController.forward(from: 0.0).then((_) {
      setState(() {
        myWordList.shuffle();
        currentIndex = 0;
        showFront = true;
      });
      if (autoPronunciation) {
        playPronunciation();
      }
    });
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
    final currentWord = myWordList.isEmpty ? null : myWordList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: currentWord == null
          ? const Center(child: Text('No words available.'))
          : Padding(
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
                    child: AnimatedBuilder(
                      animation: _flipController,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(_rotation.value),
                          alignment: Alignment.center,
                          child: Card(
                            elevation: 4,
                            child: Container(
                              height: 300.0,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: IndexedStack(
                                index: showFront ? 0 : 1,
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    currentWord.vietnamese,
                                    style: const TextStyle(fontSize: 32.0),
                                  ),
                                  Text(
                                    currentWord.english,
                                    style: const TextStyle(fontSize: 32.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: previousCard,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: nextCard,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      IconButton(
                        onPressed: shuffleWords,
                        icon: const Icon(Icons.shuffle),
                      ),
                      IconButton(
                        onPressed: toggleAutoMode,
                        icon: Icon(autoMode ? Icons.pause : Icons.play_arrow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: playPronunciation,
                  ),
                ],
              ),
            ),
    );
  }
}
