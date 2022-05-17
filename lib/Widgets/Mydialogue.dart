import 'package:flutter/material.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';

class MyDialogue extends StatelessWidget {
  String msg;
  BuildContext c;
  MyDialogue(
      {required this.msg, required this.c, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showLoaderDialog(context);
  }


  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
         content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 20),child:Text(msg)),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}
