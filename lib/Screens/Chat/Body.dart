//import 'dart:convert';
// ignore_for_file: unnecessary_statements, camel_case_types

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Chat/function.dart';
import 'package:flutter_auth/constants.dart';

User signinUser;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User user = _auth.currentUser;

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //For Flask >>>>
  String url = '';
  String output = 'Initial Output';
  final _formkey =
      GlobalKey<FormState>(); //key created to interact with the form

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText = "";
  String messageTextBot = "";

  void initState() {
    super.initState();
    getcCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            messageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xFFE1F5FE),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Container(
                        child: Form(
                          key: _formkey,
                          child: TextFormField(
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                              url = 'http://10.0.2.2:5000/api?msg=' +
                                  value.toString();
                              messageTextBot = output;
                            },
                            onSaved: (value) {},
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              hintText: 'Write your message here...',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: IconButton(
                      color: kPrimaryColor,
                      disabledColor: Colors.grey[200],
                      onPressed: () async {
                        messageText.isEmpty
                            ? null
                            : _firestore.collection("Messages").add({
                                'text': messageText,
                                'sender': signinUser.email,
                                'time': FieldValue.serverTimestamp(),
                              });
                        messageTextBot.isEmpty
                            ? null
                            : _firestore.collection("Messages").add({
                                'text': messageTextBot,
                                'sender': "mali",
                                'time': FieldValue.serverTimestamp(),
                              });
                        messageTextController.clear();
                        messageText = await fetchdata(url);
                        var decoded = jsonDecode(messageText);

                        setState(() {
                          messageText = "";
                          output = decoded['output'];
                          messageTextBot = "";
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getcCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signinUser = user;
        print(signinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
}

class messageStreamBuilder extends StatelessWidget {
  const messageStreamBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("Messages").orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<messageLine> messageWidgets = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryLightColor,
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          for (var message in messages) {
            final messagetext = message.get("text");
            final messagesender = message.get("sender");
            final curentUser = signinUser.email;
            if (curentUser == messagesender) {}
            final messagewidget = messageLine(
              text: messagetext,
              sender: messagesender,
              isMe: curentUser == messagesender,
            );
            messageWidgets.add(messagewidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              children: messageWidgets,
            ),
          );
        });
  }
}

class messageStreamBuilderBot extends StatelessWidget {
  const messageStreamBuilderBot({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection("MessagesBot").orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<messageLineBot> messageWidgets = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryLightColor,
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          for (var message in messages) {
            final messageTextBot = message.get("text");
            final messagesender = message.get("sender");
            final curentUser = signinUser.email;
            if (curentUser == messagesender) {}
            final messagewidget = messageLineBot(
              text: messageTextBot,
              sender: messagesender,
              isMe: curentUser == messagesender,
            );
            messageWidgets.add(messagewidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              children: messageWidgets,
            ),
          );
        });
  }
}

class messageLine extends StatelessWidget {
  const messageLine({this.sender, this.text, this.isMe, Key key})
      : super(key: key);
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("$sender",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
              )),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: kPrimaryLightColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class messageLineBot extends StatelessWidget {
  const messageLineBot({this.sender, this.text, this.isMe, Key key})
      : super(key: key);
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$sender",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
              )),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
