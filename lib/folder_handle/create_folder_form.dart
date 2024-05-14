import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:english_flashcard/repository/folder_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateFolderPage extends StatefulWidget {
  const CreateFolderPage({super.key});

  @override
  State<CreateFolderPage> createState() => _CreateFolderPageState();
}

class _CreateFolderPageState extends State<CreateFolderPage> {
  final _key = GlobalKey<FormState>();


  FolderRepository folderRepository = FolderRepository();

  // Variable to save value of textFormField after validate
  String myTitle = "";
  String? myDescription;
  Timestamp? myTimestamp;

  // controller of field in textFormField
  final _ctlTitle = TextEditingController();
  final _ctlDescription = TextEditingController();

  final _fcCurrPass = FocusNode();


  void _handleSubmit() {

    if (_key.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;
      FolderModel folderModel = FolderModel(
        folderName: myTitle,
        folderDes: myDescription ?? "",
        folderCreated: Timestamp.now(),
        folderIsPublic: false,
        numberOfTopic: 0,
        uid: user?.uid ?? "1",
      );

      folderRepository.createFolder(context, folderModel);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Create Folder"),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              // Title
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  focusNode: _fcCurrPass,
                  controller: _ctlTitle,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Title of folder is required";
                    }
                    myTitle = v;

                    return null;
                  },
                ),
              ),

              // Description
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _ctlDescription,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null) {
                      myDescription = "";
                      return null;
                    }
                    myDescription = v;
                    return null;
                  },
                ),
              ),

              // Submit button
              Container(
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: _handleSubmit,
                  child: const Center(
                    child: Text(
                      "Create Folder",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
