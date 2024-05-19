import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({super.key});

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  String _displayName = '';
  DateTime? _birthday;
  String _gender = 'Other';
  File? _avatar;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    // _fetchUserProfile();
  }
  //
  // Future<void> _fetchUserProfile() async {
  //   try {
  //     final User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       final userRef =
  //       FirebaseFirestore.instance.collection('users').doc(user.uid);
  //       final userData = await userRef.get();
  //       setState(() {
  //         _displayName = userData['displayName'];
  //         _birthday = userData['birthday'];
  //         _gender = userData['gender'];
  //       });
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to fetch user profile: $error'),
  //       ),
  //     );
  //   }
  // }

  Future<void> _pickImage() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          print(pickedFile.path);

          _avatar = File(pickedFile.path);
        });
        await _uploadImageToStorage();
      }
    } catch (error) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $error'),
        ),
      );
    }
  }

  Future<void> _uploadImageToStorage() async {

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (_avatar != null) {
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('avatars/${user.uid}');
          final uploadTask = storageRef.putFile(_avatar!);
          final snapshot = await uploadTask.whenComplete(() {});
          imageUrl = await snapshot.ref.getDownloadURL();
        }
      }
    } catch (error) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter New Profile Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _displayName,
                onChanged: (value) {
                  setState(() {
                    _displayName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    onPressed: _selectBirthday,
                    child: Text(
                      _birthday == null
                          ? 'Select Birthday'
                          : 'Birthday: ${_formatDate(_birthday!)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Avatar'),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                    _avatar != null ? FileImage(_avatar!) : null,
                    child: _avatar == null ? const Icon(Icons.person) : null,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _changeProfile(context);
                  }
                },
                child: const Text('Change Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeProfile(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_displayName.isNotEmpty) {
          await user.updateDisplayName(_displayName);
        }
        final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.set(
          {
            'displayName': _displayName,
            'birthday': _birthday,
            'gender': _gender,
            'image': imageUrl,
          },
          SetOptions(merge: true),
        );
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('No user signed in'),
          ),
        );
      }
    } catch (error) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $error'),
        ),
      );
    }
  }

  Future<void> _selectBirthday() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthday = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
