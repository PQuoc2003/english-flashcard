import 'package:english_flashcard/account/forgot_pass.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _isPasswordVisible = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

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
        displayName: _controllerDisplayName.text,
        confirmPassword: _controllerConfirmPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Column(
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 100,
          color: Colors.blue,
        ),
        Text(
          "Authentication",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold, // Make the title bold
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _entryField(
      String title, TextEditingController controller, bool isObscured) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscured && !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          hintText: 'Enter $title',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: title.toLowerCase().contains('password')
              ? IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed:
                      _togglePasswordVisibility, // Updated to call _togglePasswordVisibility
                )
              : IconButton(
                  icon: const Icon(Icons.clear_outlined),
                  onPressed: () {
                    controller.clear();
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildDisplayNameField() {
    if (!isLogin) {
      return _entryField('Display Name', _controllerDisplayName, false);
    }
    return const SizedBox();
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error: $errorMessage',
      style: const TextStyle(
        color: Colors.red, // Set the color to red
        fontWeight: FontWeight.bold, // Make the text bold
        fontSize: 16,
      ),
    );
  }

  Widget _buildPasswordConfirmField() {
    if (!isLogin) {
      return _entryField('Confirm Password', _controllerConfirmPassword, true);
    }
    return const SizedBox();
  }

  Widget _submitButton() {
    return SizedBox(
      width: 150,
      height: 50.0,
      child: ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        child: const Text(
          "Submit",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _sizedBox() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget _forgotPassword(BuildContext context) {
    if (isLogin) {
      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
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
              fontSize: 15,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(); // Return an empty SizedBox if not in login mode
    }
  }

  Widget _loginOrRegisterButton() {
    return SizedBox(
      width: 150, // Set width to occupy available space
      height: 50.0, // Set height to match submit button
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.black), // Add border
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        child: Text(
          isLogin ? "Register Instead" : "Login instead",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _title(),
                _buildDisplayNameField(),
                _entryField('Email', _controllerEmail, false),
                _entryField("Password", _controllerPassword, true),
                _buildPasswordConfirmField(),
                _forgotPassword(context),
                _sizedBox(),
                _errorMessage(),
                _sizedBox(),
                _submitButton(),
                _sizedBox(),
                _sizedBox(),
                _loginOrRegisterButton(),
              ],
            ),
          ),
        ));
  }
}
