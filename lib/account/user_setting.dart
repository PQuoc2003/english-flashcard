import 'package:english_flashcard/account/auth.dart';
import 'package:flutter/material.dart';
import 'change_profile_screen.dart';
import 'change_password.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  UserSettingsState createState() => UserSettingsState();
}

class UserSettingsState extends State<UserSettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Future<void> _signOut(BuildContext context) async {
    await Auth().signOut();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('User Settings'),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'signOut') {
                  _signOut(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Change Password'),
              Tab(text: 'Change Profile'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ChangePasswordPage(),
            ChangeProfileScreen(),
          ],
        ),
      ),
    );
  }
}
