// ignore_for_file: unused_field
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Chat/Chat_Sceen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
   Body({
    Key key,
  }
  ) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
var passwordContoller=TextEditingController();

var emailContoller=TextEditingController();

var formKey=GlobalKey<FormState>();

bool showpass=true;

final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
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
                type:TextInputType.emailAddress ,
                hintText: "Your Email",
                onChanged: (value) {},
                validate:   (value){
                 if(value.isEmpty){
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
                ifpressed: (){
                  setState(() {
                    showpass = !showpass;
                  });
                },
                 validate:   (value){
                    RegExp regex = new RegExp(r'^.{6,}$');
                 if(value.isEmpty){
                    return "Please Enter Your Password";
                  }
                 if (!regex.hasMatch(value)) {
                    return ("Enter Valid Password(Min. 6 Character)");
                  }
                   return null;
                  },
                text: "Password",
                onChanged: (value) {}
              ,
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  signIn(emailContoller.text, passwordContoller.text);
                },
              ),
                
          
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
                    
            ]) ),
              ),);
  }

void signIn(String email, String password) async {
    if (formKey.currentState.validate()) {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) {
                        return Chat();
                },
              ),)
                },);
      } 
    }
  }
 

