import 'package:flutter/material.dart';

class RecentHomepage extends StatefulWidget {
  const RecentHomepage({super.key});

  @override
  State<RecentHomepage> createState() => _RecentHomepageState();
}

class _RecentHomepageState extends State<RecentHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Recent"),
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Does not code yet !!!"),
          ),
        ],
      ),
    );
  }
}
