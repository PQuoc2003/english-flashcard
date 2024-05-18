import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _controller = TextEditingController();

  String email = "";

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  SnackBar snackBarMessage(String message) {
    return SnackBar(
      content: Text(message),
    );
  }

  Future resetPassword(email, context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarMessage("Password Reset Email Sent"));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarMessage(e.message ?? ""));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (email) {
                if (email != null && email.isEmpty) {
                  return "Email cannot be empty";
                } else if (email != null && !EmailValidator.validate(email)) {
                  return "Enter valid email";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                final email = _controller.text;
                if (EmailValidator.validate(email)) {
                  resetPassword(email, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackBarMessage("Please enter a valid email"));
                }
              },
              child: const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}