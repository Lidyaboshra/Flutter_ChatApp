import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_containerv.dart';
import 'package:flutter_auth/constants.dart';

class RoundedInputFieldv extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final  TextInputType type;
  final TextEditingController contoller;
  final Function validate;
  const RoundedInputFieldv({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.type,
    this.contoller,
    this.validate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainerv(
      child: TextFormField(
        validator: validate,
         controller: contoller,
          keyboardType: type,
          onChanged: onChanged,
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
            
        ),
      );
  }
}

