import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'topic_screen.dart';
import 'user_setting.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => true,
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserSettings()), // Navigate to UserSettings page
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Auth().currentUserAsync(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Home page")),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Home page")),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final User? user = snapshot.data;
          final String displayName = user?.displayName ?? "User";

          return Scaffold(
            appBar: AppBar(
              title: const Text("Home page"),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'settings') {
                      _showSettings(context);
                    } else if (value == 'signOut') {
                      _signOut(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'signOut',
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Sign Out'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(displayName),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TopicScreen()),
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