import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _showPassword = false; // Add show password state
  late TextEditingController _ctlCurrPass;
  late TextEditingController _ctlNewPass;
  late TextEditingController _ctlConfPass;
  final _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _ctlCurrPass = TextEditingController();
    _ctlNewPass = TextEditingController();
    _ctlConfPass = TextEditingController();
  }

  @override
  void dispose() {
    _ctlCurrPass.dispose();
    _ctlNewPass.dispose();
    _ctlConfPass.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget _buildPasswordVisibilityIconButton() {
    return IconButton(
      icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
      onPressed: _togglePasswordVisibility,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _ctlCurrPass,
                  obscureText: !_showPassword, // Use show password state
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: _buildPasswordVisibilityIconButton(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _ctlNewPass,
                  obscureText: !_showPassword, // Use show password state
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: _buildPasswordVisibilityIconButton(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }
                    if (v.length < 6) {
                      return "New password must at least 6 characters";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _ctlConfPass,
                  obscureText: !_showPassword, // Use show password state
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: _buildPasswordVisibilityIconButton(),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }
                    if (v.length < 6) {
                      return "New password must at least 6 characters";
                    }
                    return null;
                  },
                ),
              ),
              errorMessage == ""
                  ? Container()
                  : Text(errorMessage), // Use Text widget for error message
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

  void _handleSubmit() {
    if (_key.currentState?.validate() ?? false) {
      if (_ctlNewPass.text != _ctlConfPass.text) {
        setState(() {
          errorMessage =
          "Your new password and confirm password must be the same";
        });
        return;
      }

      final user = _auth.currentUser;

      if (user == null) {
        setState(() {
          errorMessage = "Null user, so cannot change password";
        });
        return;
      }

      _updatePassword(user, _ctlCurrPass.text, _ctlNewPass.text);
    } else {
      setState(() {
        _ctlNewPass.text = "";
        _ctlConfPass.text = "";
        errorMessage = "Error validate";
      });
    }
  }

  Future<void> _updatePassword(
      User user, String currPass, String newPass) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currPass,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPass);
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
}
