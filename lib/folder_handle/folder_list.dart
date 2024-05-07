import 'package:english_flashcard/folder_handle/create_folder_form.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:english_flashcard/repository/folder_repo.dart';
import 'package:flutter/material.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({super.key});

  @override
  State<FolderListPage> createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> {
  final FolderRepository folderRepository = FolderRepository();

  String currUID = "1";

  Widget listItems(BuildContext context, int index, FolderModel folderModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: Text(index.toString()),
        title: Text(folderModel.folderName),
        subtitle: Text(folderModel.numberOfTopic.toString()),
      ),
    );
  }

  void _createFolder() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateFolderPage()));
  }

  Widget _folderBox(String uid) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: folderRepository.getFolderByUserId(uid),
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
              // String docId = usersList[index].id;
              return listItems(context, index, folderModel);
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
            _folderBox(currUID),
          ],
        ),
      ),
    );
  }
}
