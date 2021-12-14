import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String text;
  final TextEditingController contoller;
  final Function validate;
  final Function ifpressed;
 final bool obscure;
  
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.text,
    this.contoller,
    this.validate,
    this.ifpressed,
    this.obscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      
      child: Column(
        children: [
           TextFormField(
             validator: validate,
            controller: contoller,
                obscureText: obscure,
                onChanged: onChanged,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: text,
                  icon: Icon(
                   Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: IconButton(
                icon: Icon(obscure?Icons.visibility:Icons.visibility_off,
                      color: kPrimaryColor,
                    ),
                    onPressed: ifpressed,
                  ),
                  border: InputBorder.none,
                ),
              ),
           
           
          
              
          ],
      ),
      
    );
  }}

