import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordCtrlr = TextEditingController();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    bool validateAndSave() {
      final FormState? form = _formKey.currentState;
      if (form!.validate()) {
        _showDialog(
          context,
          "Your account has been registered!",
          "please signin your account",
        );
        return true;
      }
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Register Account"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: emailController,
                  onTap: () {
                    setState(() {
                      isVisible = false;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com',
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure1,
                  onTap: () {
                    setState(() {
                      isVisible = true;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () {
                        _isObscure1 = !_isObscure1;
                      },
                      child: Icon(
                        _isObscure1 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password required!";
                    } else if (value.length < 6) {
                      return "The password must contain atleast 6 characters!";
                    } else if (!value.contains(RegExp(r'[A-Z]'))) {
                      return "The password must contain atleast one capital letter!";
                    } else if (!value.contains(RegExp(r'[0-9]{3}'))) {
                      return "The password must contain atleat 3 numbers!";
                    } else if (!value
                        .contains(RegExp(r"[.!#$%&\@'*+/=?^_`{|}~-]"))) {
                      //(?=.*[!@#$%^&*])
                      return "The password must contain atleast one special character";
                    }
                  },
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: FlutterPwValidator(
                    controller: passwordController,
                    minLength: 6,
                    uppercaseCharCount: 1,
                    numericCharCount: 3,
                    specialCharCount: 1,
                    width: 400,
                    height: 150,
                    onSuccess: () {},
                    onFail: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 20),
                child: TextFormField(
                  controller: confirmPasswordCtrlr,
                  obscureText: _isObscure2,
                  onTap: () {
                    setState(() {
                      isVisible = false;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Reenter Password',
                    hintText: 'Confirm secure password',
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscure2 = !_isObscure2;
                        });
                      },
                      child: Icon(
                        _isObscure2 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Confirm password required!";
                    } else if (value != passwordController.text) {
                      return "Password doesn't match!";
                    }
                  },
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    try {
                      if (validateAndSave() &
                          EmailValidator.validate(emailController.text)) {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: confirmPasswordCtrlr.text.trim(),
                        );
                        emailController.clear();
                        passwordController.clear();
                        confirmPasswordCtrlr.clear();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.message == "invalid-email") {
                        _showDialog(context, "Invalid email",
                            "Please enter a valid email!");
                      }
                    } catch (e) {
                      print("The e is: $e");
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
            ],
          ),
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
