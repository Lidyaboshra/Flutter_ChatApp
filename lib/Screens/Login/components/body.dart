import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Login/forgetpassword.dart';

import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Chat/Chat_Sceen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Body extends StatefulWidget {
  Body({
    Key key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var passwordContoller = TextEditingController();

  var emailContoller = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool showpass = true;

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Image.asset(
                      "assets/icons/smile.jpg",
                      // height: size.height * 0.35,
                    ),
                    SizedBox(height: size.height * 0.03),
                    RoundedInputField(
                      contoller: emailContoller,
                      type: TextInputType.emailAddress,
                      hintText: "Your Email",
                      onChanged: (value) {},
                      validate: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Your Email";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                    ),
                    RoundedPasswordField(
                      contoller: passwordContoller,
                      obscure: showpass,
                      ifpressed: () {
                        setState(() {
                          showpass = !showpass;
                        });
                      },
                      validate: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value.isEmpty) {
                          return "Please Enter Your Password";
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                        return null;
                      },
                      text: "Password",
                      onChanged: (value) {},
                    ),
                    Center(
                      child: Text(errorMessage),
                    ),
                    GestureDetector(
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: kPrimaryColor,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResetScreen()));
                        }),
                    RoundedButton(
                        text: "LOGIN",
                        press: () {
                          signIn(emailContoller.text, passwordContoller.text);
                          setState(() {
                            emailContoller.text = "";
                            passwordContoller.text = "";
                          });
                        }),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                    )
                  ])),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (formKey.currentState.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Chat();
                      },
                    ),
                  )
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }
}
