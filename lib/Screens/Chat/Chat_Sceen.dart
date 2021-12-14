import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Chat/Body.dart';
import 'package:flutter_auth/constants.dart';

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
          ),

          body: Body(),
   );
  }
}