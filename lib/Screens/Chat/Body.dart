//import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
//import 'package:http/http.dart' as http;

User signinUser;
final _firestore=FirebaseFirestore.instance;
class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //For Flask >>>>
  String greetings = "";
  String name = ""; //user's response will be assigned to this variable
  String final_response =""; //will be displayed on the screen once we get the data from the server
  final _formkey =
      GlobalKey<FormState>(); //key created to interact with the form

  Future<void> _savingData() async {
    final validation = _formkey.currentState.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState.save();
  }


  final messageTextController=TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText="";


  void initState(){
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
            // Center(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
                 
            //       //For Flask >>>>
            //       // Text(
            //       //   greetings,
            //       //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //       // ),
            //     ],
            //   ),
            // ),
            
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
                            controller:messageTextController,
                            onChanged: (value) {
                              messageText=value;
                            },
                            onSaved: (value) {
                              name = value;
                            },
                            decoration: InputDecoration(
                              enabledBorder:UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ) ,
                             
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 20,
                  //   ),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: kPrimaryColor,
                  //     ),
                  //     child: TextButton(
                  //       onPressed: ()  {
                  //         messageTextController.clear();
                  //         _firestore.collection("Messages").add({
                  //           'text':messageText,
                  //           'sender':signinUser.email,
                  //           'time':FieldValue.serverTimestamp(),
                  //         });
                        
                  //         // For Flask >>>>
                  //         //   String url = 'http://127.0.0.1:5000/';
                  //         //   final response = await http.get(
                  //         //   Uri.parse(url),
                  //         //   );
                           
                  //         //   final decoded = json.decode(response.body) as Map< String , dynamic>;

                  //         //  setState(() {
                  //         //    greetings = decoded['greetings'];
                  //         //  });
                  //       },
                  //       child: Text(
                  //         'Send',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                 Padding(
                     padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                   child: IconButton(
                    color: kPrimaryColor,
                    disabledColor: Colors.grey[200],
                    onPressed:(){
                    messageText.isEmpty ? null:
                            _firestore.collection("Messages").add({
                              'text':messageText,
                              'sender':signinUser.email,
                              'time':FieldValue.serverTimestamp(),
                            });
                      messageTextController.clear();
                      setState(() {
                        messageText="";
                      });
                 
                    } , 
                    icon: Icon(Icons.send,size: 25,),
                    ),
                 ),
                  //for post http
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 20,
                  //   ),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: kPrimaryColor,
                  //     ),
                  //     child: TextButton(
                  //       onPressed: () async {
                  //         //For Flask >>>>
                  //         //         final url = 'http://127.0.0.1:5000/name';

                  //         // //getting data from the python server script and assigning it to response
                  //         // final response = await http.get(url);

                  //         // //converting the fetched data from json to key value pair that can be displayed on the screen
                  //         // final decoded = json.decode(response.body) as Map<String, dynamic>;

                  //         // //changing the UI be reassigning the fetched data to final response
                  //         // setState(() {
                  //         //   final_response = decoded['name'];
                  //         // });
                  //       },
                  //       child: Text(
                  //         'Post',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //For Flask
                //  Text(final_response, style: TextStyle(fontSize: 24),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getcCurrentUser(){
    try{ 
       final user=_auth.currentUser;
       if(user!= null){
       signinUser = user;
       print(signinUser.email);
    }
    }catch(e){
      print(e);
    }
  }

  // void getMessages() async{
  //  final messages = await _firestore.collection("Messages").get();
  //  for(var message in messages.docs){
  //    print(message.data());
  //  }
  // }

  // void messageStream() async{
  //    await for( var snapshot in _firestore.collection("Messages").snapshots()){
  //     for( var message in snapshot.docs){
  //       print(message.data());
  //     }
  //    }
  // }
}

class messageStreamBuilder extends StatelessWidget {
  const messageStreamBuilder({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("Messages").orderBy('time').snapshots(),
                builder: (context, snapshot){
                  List<messageLine> messageWidgets=[];
                  if(!snapshot.hasData){
                    return Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryLightColor,
                        ),
                    );
                  }
                  final messages=snapshot.data.docs.reversed;
                  for (var message in messages) {
                    final messagetext=message.get("text");
                    final messagesender=message.get("sender");
                    final curentUser=signinUser.email;
                    if(curentUser==messagesender){

                    }
                    final messagewidget=messageLine(
                      text:messagetext,
                      sender: messagesender,
                      isMe: curentUser==messagesender,
                      );
                    messageWidgets.add(messagewidget);
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      children: messageWidgets, 
                    ),
                  );
                }
                );
  }
}

class messageLine extends StatelessWidget {
  const messageLine({this.sender,this.text,this.isMe, Key key }) : super(key: key);
  final String sender;
  final String text;
  final bool isMe;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(fontSize:12,
            color:Colors.black45,
            )
            ),
          
          Material(
            elevation: 5,
            borderRadius:isMe?BorderRadius.only(
              topLeft:Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ): BorderRadius.only(
              topRight:Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              ),
            color: isMe?kPrimaryLightColor:kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 18,color: isMe?Colors.black:Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}