import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Chat/Chat_Sceen.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/imagepicker.dart';
// import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
// import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/usermodel/usermodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  get import => null;

  var passwordContoller = TextEditingController();

  var confirmpasswordContoller = TextEditingController();

  var emailContoller = TextEditingController();

  var firstname = TextEditingController();

  var lastname = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool showpass = true;

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  File userImage;

  void pickImage(File _pickedImage) {
    userImage = _pickedImage;
  }

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
                  "SIGNUP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),

                UserPick(pickImage),
                //FirstName Field
                RoundedInputField(
                  hintText: "First Name",
                  contoller: firstname,
                  type: TextInputType.name,
                  onChanged: (value) {},
                  validate: (value) {
                    RegExp regex = new RegExp(r'^.{3,}$');
                    if (value.isEmpty) {
                      return "Please Enter First Name";
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid name(Min. 3 Character)");
                    }
                    return null;
                  },
                ),

                //LastName Field
                RoundedInputField(
                  hintText: "Last Name",
                  contoller: lastname,
                  type: TextInputType.name,
                  onChanged: (value) {},
                  validate: (value) {
                    if (value.isEmpty) {
                      return "Please Enter Your Last Name";
                    }
                    return null;
                  },
                ),

                //Email Field
                RoundedInputField(
                  hintText: "Your Email",
                  type: TextInputType.emailAddress,
                  icon: Icons.email,
                  onChanged: (value) {},
                  contoller: emailContoller,
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

                //Password Field
                RoundedPasswordField(
                  text: "Password",
                  obscure: showpass,
                  contoller: passwordContoller,
                  ifpressed: () {
                    setState(() {
                      showpass = !showpass;
                    });
                  },
                  onChanged: (value) {},
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
                ),

                //ConfirmPassword Field
                RoundedPasswordField(
                  text: "Confirm Password",
                  obscure: showpass,
                  contoller: confirmpasswordContoller,
                  ifpressed: () {
                    setState(() {
                      showpass = !showpass;
                    });
                  },
                  onChanged: (value) {},
                  validate: (value) {
                    if (confirmpasswordContoller.text !=
                        passwordContoller.text) {
                      return "Password don't match";
                    }
                    return null;
                  },
                ),

                RoundedButton(
                    text: "SIGNUP",
                    press: () {
                      signUp(emailContoller.text, passwordContoller.text,
                          userImage);
                    }),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                // OrDivider(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     SocalIcon(
                //       iconSrc: "assets/icons/facebook.svg",
                //       press: (){
                //         //signInWithFacebook(emailContoller.text, passwordContoller.text);
                //       }
                //     ),
                //     // SocalIcon(
                //     //   iconSrc: "assets/icons/twitter.svg",
                //     //   press: () {
                //     //     //signUpWithMail();
                //     //   },
                //     // ),
                //     SocalIcon(
                //       iconSrc: "assets/icons/gmail.svg",
                //       press: () {
                //        // signInWithGoogle(emailContoller.text, passwordContoller.text);
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, File image) async {
    if (formKey.currentState.validate()) {
      await _auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }

//   // void signInWithGoogle(String email, String password) async {
//   //   // Trigger the authentication flow
//   //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

//   //   // Obtain the auth details from the request
//   //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//   //   // Create a new credential
//   //   final credential = GoogleAuthProvider.credential(
//   //     accessToken: googleAuth.accessToken,
//   //     idToken: googleAuth.idToken,
//   //   );
//   //  await _auth.signInWithCredential(credential)
//   //           .then((value) => {postDetailsToFirestore()})
//   //           .catchError((e) {
//   //         Fluttertoast.showToast(msg: e.message);

//   //       });

//   // }

// void signInWithGoogle(String email, String password) async {
//   final GoogleSignInAccount googleuser = await GoogleSignIn().signIn();

//   final GoogleSignInAuthentication googleAuth = await googleuser.authentication;

//   final
//   GoogleAuthCredential credential = GoogleAuthProvider.credential(
//      idToken: googleAuth.idToken,
//      accessToken: googleAuth.accessToken
//   );
//    await FirebaseAuth.instance.signInWithCredential(credential).then((value) => {postDetailsToFirestore()})
//             .catchError((e) {
//           Fluttertoast.showToast(msg: e.message);

//         });

// }

  // Future<UserCredential> signInWithFacebook(String email, String password) async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login(
  //    // permissions: ['email', 'password', 'name']
  //   );

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
  //     loginResult.accessToken.token);

  //    postDetailsToFirestore();
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child("User_Image")
        .child(user.uid + '.jpg');
    await ref.putFile(userImage);
    final url = await ref.getDownloadURL();

    UserModel userModel = UserModel();
    // writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.firstName = firstname.text;
    userModel.secondName = lastname.text;
    userModel.image = url;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Chat();
        },
      ),
    );
  }
}
