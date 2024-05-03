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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Center(
              child: TextFormField(

                controller: _controller,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (email) {
                  if (email != null && !EmailValidator.validate(email)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(

            onPressed: () {
              email = _controller.text;
              resetPassword(email, context);
            },
            child: const Text("Hello"),
          ),
        ],
      ),
    );
  }
}
