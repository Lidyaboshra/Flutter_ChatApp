import 'package:flutter/material.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/constants.dart';

class Setting extends StatefulWidget {
  const Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor, title: Text("Settings")),
      body: Column(
        children: [
          Center(child: RoundedButton(text: "Update Password", press: () {}))
        ],
      ),
    );
  }

  // void _changePassword(String currentPassword, String newPassword) async {
  //   final user = await FirebaseAuth.instance.currentUser;
  //   final cred = EmailAuthProvider.credential(
  //       email: user.email, password: currentPassword);

  //   user.reauthenticateWithCredential(cred).then((value) {
  //     user.updatePassword(newPassword).then((_) {
  //       print("Successfully changed password");
  //     }).catchError((error) {
  //       print("Password can't be changed" + error.toString());
  //     });
  //   }).catchError((err) {});
  // }
}
