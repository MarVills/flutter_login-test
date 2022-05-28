import 'package:auth_login/screens/register.dart';
import 'package:auth_login/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:auth_login/screens/social_auth/login_with_google.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool validateAndSave() {
      final FormState? emailForm = _emailFormKey.currentState;
      final FormState? passwordForm = _passFormKey.currentState;
      if (emailForm!.validate() & passwordForm!.validate()) {
        return true;
      }
      return false;
    }

    void _togglePasswordView() {
      setState(() {
        _isObscure = !_isObscure;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 100,
                ),
              ),
            ),
            Form(
              key: _emailFormKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email ex. \"abc@gmail.com\"',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email is required!";
                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                  },
                ),
              ),
            ),
            Form(
              key: _passFormKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password required!";
                    }
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final FormState? emailForm = _emailFormKey.currentState;
                if (emailForm!.validate()) {
                  await _auth.sendPasswordResetEmail(
                      email: emailController.text);
                  _showDialog(
                    context,
                    "Reset your password using email!",
                    "Check your email and continue reseting your password by clicking the link",
                  );
                }
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 30,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: TextButton(
                onPressed: () async {
                  try {
                    if (validateAndSave()) {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                      emailController.clear();
                      passwordController.clear();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      _showDialog(
                        context,
                        "Password is incorrect",
                        "Please enter the correct pasword!",
                      );
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              Buttons.Google,
              text: 'Sign in with Google',
              onPressed: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
                //signInWithGoogle();
              },
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              Buttons.Facebook,
              text: 'Sign in with Facebook',
              onPressed: () {},
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text(
                'New User? Create Account',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
