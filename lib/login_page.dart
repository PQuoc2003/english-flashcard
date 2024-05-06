import 'package:english_flashcard/account/forgot_pass.dart';
import 'package:english_flashcard/models/users_model.dart';
import 'package:english_flashcard/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text("Firebase Auth");
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Error ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(
        isLogin ? "Login" : "Register",
      ),
    );
  }

  Widget _sizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _forgotPassword(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ForgotPasswordPage(),
          ),
        );
      },
      child: Text(
        "Forgot Password",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? "Register Instead" : "Login instead"),
    );
  }

  // button test
  Widget createButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        createUser(context);
      },
      child: const Text(
        "Test connect firestore",
      ),
    );
  }

  // function firebase test
  void createUser(BuildContext context) {
    UserRepository userRepository = UserRepository();

    UserModel userModel = UserModel(uid: "1", fullName: "Quoc", gender: "Male");

    userRepository.createUser(context, userModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField("password", _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _sizedBox(),
            _forgotPassword(context),
            _sizedBox(),
            _loginOrRegisterButton(),
            // test firebase
            createButton(context),
          ],
        ),
      ),
    );
  }
}
