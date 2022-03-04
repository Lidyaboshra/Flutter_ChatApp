import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Chat/Body.dart';
import 'package:flutter_auth/constants.dart';

final _auth=FirebaseAuth.instance;
class Chat extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title:Text("MessageMe"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
          size: 20,
          color: Colors.black),),
        actions: [
          IconButton(
          icon:Icon(Icons.close_outlined,),
            onPressed: () {
              _auth.signOut();
            Navigator.pop(context,);
          },
            ),
        ],
          ),

          body: Body(),
   );
  }
}