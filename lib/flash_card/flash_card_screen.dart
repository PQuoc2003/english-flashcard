import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardScreen extends StatefulWidget {
  final List wordList;

  const FlashcardScreen({super.key, required this.wordList});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

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
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _frontRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: pi / 2), weight: 50),
      TweenSequenceItem(tween: ConstantTween<double>(pi / 2), weight: 50),
    ]).animate(_flipController);
    _backRotation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(pi / 2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -pi / 2, end: 0.0), weight: 50),
    ]).animate(_flipController);
    initSequence();
    _initTts();
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
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
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
    pronunciationDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await flutterTts.speak(showFront ? myWordList[currentIndex].vietnamese : myWordList[currentIndex].english);
    });
  }

  void flipCard() {
    if (_flipController.isAnimating) return;
    if (_flipController.isCompleted || _flipController.isDismissed) {
      _flipController.forward(from: 0.0).then((_) {
        setState(() {
          showFront = !showFront;
        });
      });
    }
  }

  void nextCard() {
    if (_flipController.isAnimating) return;
    _flipController.forward(from: 0.0).then((_) {
      setState(() {
        currentIndex = (currentIndex + 1) % myWordList.length;
        showFront = true;
      });
      if (autoPronunciation) {
        playPronunciation();
      }
    });
  }

  void previousCard() {
    if (_flipController.isAnimating) return;
    _flipController.forward(from: 0.0).then((_) {
      setState(() {
        currentIndex = (currentIndex - 1 + myWordList.length) % myWordList.length;
        showFront = true;
      });
      if (autoPronunciation) {
        playPronunciation();
      }
    });
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
    });
    if (autoMode) {
      autoModeTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        nextCard();
      });
    } else {
      autoModeTimer?.cancel();
    }
  }

  Widget buildCard(BuildContext context, String text, bool isFront) {
    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, child) {
        final rotation = isFront ? _frontRotation.value : _backRotation.value;
        return Transform(
          transform: Matrix4.rotationY(rotation),
          child: rotation <= pi / 2
              ? Card(
            child: Center(
              child: Text(text, style: const TextStyle(fontSize: 24.0)),
            ),
          )
              : Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: Card(
              child: Center(
                child: Text(text, style: const TextStyle(fontSize: 24.0)),
              ),
            ),
          ),
        );
      },
      child: Card(
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 24.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = myWordList[currentIndex];
    final text = showFront ? currentWord.vietnamese : currentWord.english;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            icon: Icon(autoMode ? Icons.pause : Icons.play_arrow),
            onPressed: toggleAutoMode,
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: shuffleWords,
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: flipCard,
          child: buildCard(context, text, showFront),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: previousCard,
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: nextCard,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}