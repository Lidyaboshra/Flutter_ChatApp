import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Chat/Body.dart';
import 'package:flutter_auth/Screens/Chat/sidemenu.dart';
import 'package:flutter_auth/constants.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("MessageMe"),

        // leading: IconButton(
        //   onPressed: () {
        //     NavDrawer();
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.menu_outlined, size: 20, color: Colors.black),
        // ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.close_outlined,
        //     ),
        //     onPressed: () {
        //       _auth.signOut();
        //       Navigator.pop(
        //         context,
        //       );
        //     },
        //   ),
        //  ],
      ),
      body: Body(),
    );
  }
}
