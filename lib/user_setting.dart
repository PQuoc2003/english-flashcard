import 'package:flutter/material.dart';
import 'account/change_profile_screen.dart';
import 'account/change_password.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          title: const Text('User Settings'),
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
