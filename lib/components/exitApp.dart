/*
退出应用确认框
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<bool> exitApp(context) {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text('是否退出应用？'),
        actions:<Widget>[
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            child: Text('退出'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
}

