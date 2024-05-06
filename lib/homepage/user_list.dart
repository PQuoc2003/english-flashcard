import 'package:english_flashcard/models/users_model.dart';
import 'package:english_flashcard/repository/user_repo.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final UserRepository userRepository = UserRepository();


  Widget listItems(BuildContext context, int index, UserModel userModel) {
    return Padding(padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10,
    ),
      child: ListTile(
        leading: Text(index.toString()),
        title: Text(userModel.fullName),
        subtitle: Text(userModel.uid),
      ),
    );
  }


  Widget _userBox() {
    return SizedBox(
      height: MediaQuery
          .sizeOf(context)
          .height * 0.8,
      width: MediaQuery
          .sizeOf(context)
          .width,
      child: StreamBuilder(
        stream: userRepository.getUser(),
        builder: (context, snapshots) {
          List usersList = snapshots.data?.docs ?? [];
          if (usersList.isEmpty) {
            return const Center(child: Text("No user"),);
          }
          return ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              UserModel userModel = usersList[index].data();
              // String docId = usersList[index].id;
              return listItems(context, index, userModel);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _userBox(),
          ],
        ),
      ),
    );
  }
}
