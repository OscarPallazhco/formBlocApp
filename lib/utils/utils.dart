
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


bool isNumeris(String s){
  if (s.isEmpty) return false;
  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void showAlert(BuildContext context, String title, String message, {void Function() callback}){
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          MaterialButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
              if (callback != null) {
                callback();
              }
            },
          )
        ],
      )
    );
  } else if(Platform.isIOS){
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),        
        content: CupertinoActivityIndicator(),
        actions: [
          CupertinoButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      )
    );
  }
}

void showLoading(BuildContext context){
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Espere...'),
        content: LinearProgressIndicator(),
      )
    );
  } else if(Platform.isIOS){
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Espere...'),
        content: CupertinoActivityIndicator(),
      )
    );
  }
}