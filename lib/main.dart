import 'package:english_flashcard/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'flutter-quizzlet',
      options: const FirebaseOptions(
          apiKey: "AIzaSyAUncrzUEn62dqG8CIhLPcJprnXarV5q3Y",
          authDomain: "flutter-quizzlet.firebaseapp.com",
          databaseURL: "https://flutter-quizzlet-default-rtdb.firebaseio.com",
          projectId: "flutter-quizzlet",
          storageBucket: "flutter-quizzlet.appspot.com",
          messagingSenderId: "769030931603",
          appId: "1:769030931603:android:17709d3069cf0c2037f966",
          measurementId: "G-5QGE2EB3X4"
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WidgetTree(),
    );
  }
}

