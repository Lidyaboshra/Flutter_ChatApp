// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_auth/components/rounded_button.dart';
// import 'package:flutter_auth/components/rounded_input_field.dart';
// import 'package:flutter_auth/constants.dart';

// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({Key key}) : super(key: key);

//   @override
//   _ForgetPasswordState createState() => _ForgetPasswordState();
// }

// var formKey = GlobalKey<FormState>();
// var emailContoller = TextEditingController();

// class _ForgetPasswordState extends State<ForgetPassword> {
//   void dipose() {
//     emailContoller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(backgroundColor: kPrimaryColor, title: Text("Reset Password")),
//       body: SingleChildScrollView(
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                   child: RoundedInputField(
//                 contoller: emailContoller,
//                 hintText: "Email",
//                 icon: null,
//                 validate: (email) =>
//                     email != null && EmailValidator.validate(email)
//                         ? 'Enter a valid Email'
//                         : null,
//               )),
//               Center(
//                   child: RoundedButton(text: "Reset Password", press: () {})),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future ResetPassword() async {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Center(
//               child: CircularProgressIndicator,
//             ));
//     try {
//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: emailContoller.text.trim());
//       Utils.ShowSnackBar("Password Reset Email sent");
//     } on FirebaseAuthException catch (e) {
//       print(e);
//       Utils.ShowSnackBar(e.message);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/constants.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundedButton(
                text: 'Send Request',
                press: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
