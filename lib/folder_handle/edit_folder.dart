import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:english_flashcard/repository/folder_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditFolderPage extends StatefulWidget {
  const EditFolderPage({
    super.key,
    required this.folderModel,
    required this.folderId,
  });

  final FolderModel folderModel;
  final String folderId;

  @override
  State<EditFolderPage> createState() => _EditFolderPageState();
}

class _EditFolderPageState extends State<EditFolderPage> {
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
      FolderModel updatedFolder = FolderModel(
        folderName: myTitle,
        folderDes: myDescription ?? "",
        folderCreated: Timestamp.now(),
        folderIsPublic: false,
        numberOfTopic: 0,
        uid: user?.uid ?? "1",
      );

      folderRepository.updateFolder(widget.folderId, updatedFolder);

      // folderRepository.createFolder(context, folderModel);

      Navigator.pop(context);
    }
  }

  void assignValueToForm() {
    _ctlTitle.text = widget.folderModel.folderName;
    _ctlDescription.text = widget.folderModel.folderDes;
  }

  @override
  void initState() {
    super.initState();
    assignValueToForm();
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
                      "Update Folder",
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
