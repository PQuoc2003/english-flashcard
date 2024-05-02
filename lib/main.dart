import 'package:english_flashcard/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'flutter-quizzlet',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBa4b8GAc9SXI7SgUbn8EkI6SWC9UFzFcU',
        appId: '1:769030931603:android:433985001ce1bd2437f966',
        messagingSenderId: 'sendid',
        projectId: 'flutter-quizzlet',
        storageBucket: 'flutter-quizzlet.appspot.com',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WidgetTree(),
    );
  }
}

