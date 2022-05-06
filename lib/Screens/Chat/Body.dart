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
            // messageStreamBuilderBot(),
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
                                'sender': "maliapp@api.com",
                                'time': FieldValue.serverTimestamp(),
                              });
                        messageTextController.clear();
                        messageText = await fetchdata(url);
                        var decoded = (messageText);

                        setState(() {
                          messageText = "";
                          output = decoded;
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
            var messagetext = message.get("text");
            var messageTextBot = message.get("text");
            var messagesenderBot = "maliapp@api.com";
            var messagesender = message.get("sender");
            // var curentUser = signinUser.email;
            if (messagesender == "maliapp@api.com") {
              var messagewidget = messageLine(
                text: messageTextBot,
                sender: messagesenderBot,
                isMe: false,
                type: "bot",
              );
              messageWidgets.add(messagewidget);
            } else {
              var messagewidget = messageLine(
                text: messagetext,
                sender: messagesender,
                isMe: true,
                type: "user",
              );
              messageWidgets.add(messagewidget);
            }
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

// class messageStreamBuilderBot extends StatelessWidget {
//   const messageStreamBuilderBot({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream:
//             _firestore.collection("MessagesBot").orderBy('time').snapshots(),
//         builder: (context, snapshot) {
//           List<messageLine> messageWidgets = [];
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: kPrimaryLightColor,
//               ),
//             );
//           }
//           var messages = snapshot.data.docs.reversed;
//           for (var message in messages) {
//             var messageTextBot = message.get("text");
//             var messagesender = "maliapp@api.com";
//             var curentUser = "maliapp@api.com";
//             if (curentUser == "maliapp@api.com") {
//               var messagewidget = messageLine(
//                 text: messageTextBot,
//                 sender: messagesender,
//                 isMe: false,
//                 type: "bot",
//               );
//               messageWidgets.add(messagewidget);
//             }
//           }

//           return Expanded(
//             child: ListView(
//               reverse: true,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//               children: messageWidgets,
//             ),
//           );
//         });
//   }
// }

class messageLine extends StatelessWidget {
  const messageLine({this.sender, this.text, this.isMe, this.type, Key key})
      : super(key: key);
  final String sender;
  final String text;
  final bool isMe;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            type == "user" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text("$sender",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
              )),
          Material(
            elevation: 5,
            borderRadius: type == "user"
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: type == "user" ? kPrimaryLightColor : kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 18,
                    color: type == "user" ? Colors.black : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class messageLine extends StatelessWidget {
//   const messageLine({this.sender, this.text, this.isMe, Key key})
//       : super(key: key);
//   final String sender;
//   final String text;
//   final bool isMe;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text("$sender",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.black45,
//               )),
//           Material(
//             elevation: 5,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//             color: kPrimaryLightColor,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 '$text',
//                 style: TextStyle(fontSize: 18, color: Colors.black),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class messageLineBot extends StatelessWidget {
//   const messageLineBot({this.sender, this.text, this.isMe, Key key})
//       : super(key: key);
//   final String sender;
//   final String text;
//   final bool isMe;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("$sender",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.black45,
//               )),
//           Material(
//             elevation: 5,
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//             color: kPrimaryColor,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 '$text',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
