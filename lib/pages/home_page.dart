import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
class HomePage extends StatefulWidget{
 final Map params;
     HomePage({
        Key key,
        this.params,
      }) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  //退出app检测
  Future<bool> _exit() {
    return showDialog(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
            return CupertinoAlertDialog(
            title: Text('是否退出应用？'),
            actions:<Widget>[

            CupertinoDialogAction(
            child: Text('取消'),
            onPressed: (){
                Navigator.of(context).pop();
             },
            ),
            CupertinoDialogAction(
            child: Text('退出'),
            onPressed: (){
                Navigator.of(context).pop();
            },
            ),
            ],
            );
            },
    );
  }

  //导航栏

  var MianWarp=new Stack(
     children: <Widget>[
       Container(
         width: double.infinity,
         height: double.infinity,
         color:Colors.lightBlue,
         child: Text('vdv'),
       ),
       Align(
         alignment: Alignment.bottomCenter,
         child: Container(
           width: double.infinity,
           height: 50.0,
           decoration: BoxDecoration(color: Colors.white70),
           child: Text('播放状态'),
         ),
       ),
     ],
  );


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _exit,
        child:Material(
          color:Colors.redAccent,
            child: Container(
              margin:EdgeInsets.fromLTRB(0,MediaQueryData.fromWindow(window).padding.top,0,0),
              color:Colors.white,
              child: MianWarp,
            ),
      )
    );
  }
}