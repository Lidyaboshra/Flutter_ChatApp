import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/rounded_buttonv.dart';
import 'package:flutter_auth/constants.dart';

import 'package:image_picker/image_picker.dart';

class UserPick extends StatefulWidget {

  final void Function(File _pickedImage ) imagePicFn;

   UserPick(this.imagePicFn);

  @override
  _UserPickState createState() => _UserPickState();
}

class _UserPickState extends State<UserPick> {
 File pickedImage;
  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource src) async{

    final pickedImageFile = await _picker.pickImage(source: src, imageQuality: 50,maxWidth: 150);

    if(pickedImageFile!= null){
      setState(() {
        pickedImage= File(pickedImageFile.path);
      });
      widget.imagePicFn(pickedImage);
    }else{
      print("NO Image Selected");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: kPrimaryLightColor,
          backgroundImage: pickedImage != null? FileImage(pickedImage):null,
        ),
       SizedBox(height: 10),
       Container(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
                   RoundedButtonv(
                    text: ("Add Image\nFrom Camera"),
                    press: () {
                      pickImage(ImageSource.camera);
                      }),
                
                   RoundedButtonv(
                    text: "Add Image\nFrom Gallery",
                    press: () {
                      pickImage(ImageSource.gallery);
                      }),
                  
           ],
         ),
       )
      ],
    );
  }}

  