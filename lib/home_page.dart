import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'topic_screen.dart'; // Import your TopicScreen here

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Auth().currentUserAsync(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Firebase Auth")),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Firebase Auth")),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final User? user = snapshot.data;
          final String displayName = user?.displayName ?? "User";

          return Scaffold(
            appBar: AppBar(
              title: const Text("Firebase Auth"),
              actions: [
                IconButton(
                  onPressed: () => signOut(context),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(displayName),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TopicScreen()),
                      );
                    },
                    child: const Text("Go to Topics"),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
