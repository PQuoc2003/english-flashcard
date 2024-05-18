import 'package:english_flashcard/folder_handle/create_folder_form.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:english_flashcard/repository/folder_repo.dart';
import 'package:english_flashcard/topic_handle/topic_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({super.key});

  @override
  State<FolderListPage> createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> {
  final FolderRepository folderRepository = FolderRepository();


  @override
  void initState() {
    super.initState();
// Initialize filter index
  }

  Widget listItems(BuildContext context, int index, FolderModel folderModel, String folderId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(index.toString()),
        ),
        title: Text(folderModel.folderName),
        subtitle: Text('${folderModel.numberOfTopic} topics'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => TopicListPage(
                mode: 1,
                folderId: folderId,
                folderModel: folderModel,
              ),
            ),
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateFolderPage(
                      // folderModel: folderModel,
                      // folderId: folderId,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                folderRepository.deleteFolder(context, folderId);
              },
            ),
          ],
        ),
      ),
    );
  }


  void _createFolder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateFolderPage(),
      ),
    );
  }

  Widget _folderBox() {
    final user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: folderRepository.getFolderByUserId(user?.uid ?? "2"),
        builder: (context, snapshots) {
          List folderList = snapshots.data?.docs ?? [];
          if (folderList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No folder"),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    onPressed: _createFolder,
                    child: const Text("Create folder"),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Folders'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _createFolder,
          child: const Icon(Icons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: _folderBox()),
          ],
        ),
      ),
    );
  }
}
