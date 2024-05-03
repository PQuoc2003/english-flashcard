import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _key = GlobalKey<FormState>();

  // firebase user
  final _auth = FirebaseAuth.instance;

  // Variable to save value of textFormField after validate
  String currPass = "";
  String newPass = "";
  String confPass = "";

  // controller of field in textFormField
  final _ctlCurrPass = TextEditingController();
  final _ctlNewPass = TextEditingController();
  final _ctlConfPass = TextEditingController();

  // focusNode of field

  final _fcCurrPass = FocusNode();

  String errorMessage = "";

  Future<void> updatePassword(
      User user, String currPass, String newPass) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currPass,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPass);
      // Password updated successfully
      // You can navigate to another page or show a success message

      setState(() {
        errorMessage = "Update Password successfully";
      });


    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to update password. Please check your current password.';
      });
    }
  }

  void _handleSubmit() {
    if (_key.currentState?.validate() ?? false) {
      if (newPass != confPass) {
        setState(() {
          errorMessage =
              "Your new password and confirm password must be the same";
        });

        return;
      }

      final user = _auth.currentUser;

      if (user == null) {
        setState(() {
          errorMessage = "Null user , so can not change password";
        });
        return;
      }

      updatePassword(user, currPass, newPass);

    } else {
      setState(() {
        _ctlNewPass.text = "";
        _ctlConfPass.text = "";
        errorMessage = "Error validate";
      });
    }
  }

  Widget _errorBox(String errorMessage) {
    return Text(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Update Password"),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              // Current Password
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  focusNode: _fcCurrPass,
                  controller: _ctlCurrPass,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }

                    currPass = v;

                    return null;
                  },
                ),
              ),

              // New password
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _ctlNewPass,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }

                    if (v.length < 6) {
                      return "New password must at least 6 characters";
                    }

                    newPass = v;

                    return null;
                  },
                ),
              ),

              // Confirm password
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _ctlConfPass,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }

                    if (v.length < 6) {
                      return "New password must at least 6 characters";
                    }

                    confPass = v;

                    return null;
                  },
                ),
              ),

              // Error after validate
              errorMessage == "" ? Container() : _errorBox(errorMessage),

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
                      "Update Password",
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
