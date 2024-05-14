import 'package:english_flashcard/folder_handle/create_folder_form.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:english_flashcard/repository/folder_repo.dart';
import 'package:english_flashcard/topic_handle/topic_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({super.key});

  @override
  State<FolderListPage> createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> {
  final FolderRepository folderRepository = FolderRepository();

  Widget listItems(BuildContext context, int index, FolderModel folderModel,
      String folderId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: Text(index.toString()),
        title: Text(folderModel.folderName),
        subtitle: Text(folderModel.numberOfTopic.toString()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => TopicListPage(mode: 1, folderId: folderId, folderModel: folderModel,),
            ),
          );
        },
      ),
    );
  }

  void _createFolder() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateFolderPage()));
  }

  Widget _folderBox() {
    final user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: folderRepository.getFolderByUserId(user?.uid ?? "2"),
        builder: (context, snapshots) {
          List folderList = snapshots.data?.docs ?? [];
          if (folderList.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Text("No folder"),
                  ElevatedButton(
                    onPressed: _createFolder,
                    child: const Center(
                      child: Text("Create folder"),
                    ),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: folderList.length,
            itemBuilder: (context, index) {
              FolderModel folderModel = folderList[index].data();
              String docId = folderList[index].id;
              return listItems(context, index, folderModel, docId);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _folderBox(),
            ],
          ),
        ),
      ),
    );
  }
}
