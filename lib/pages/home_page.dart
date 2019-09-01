import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';

import 'package:flutter/widgets.dart' as prefix1;
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




  @override
  Widget build(BuildContext context) {

    //导航栏
    //当前播放歌曲

    var playPanel=new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CircleAvatar(
          radius:20,
          backgroundImage:  NetworkImage('https://p3.music.126.net/9VIOwab-rAcTB9fUzvG2_g==/3424978722057092.jpg?param=300y300'),
        ),
        Expanded(
        child:Padding(
        padding: const EdgeInsets.fromLTRB(5.0,0,5.0,0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('假如爱有天意（粤语）csdvsdvsdbsdbs假如爱有天意（粤语）', overflow: TextOverflow.ellipsis,style:TextStyle(),),
            Text('谷祖林',style:TextStyle(color:Colors.black45)),
          ],
        ),)

        ),
        RaisedButton(
            onPressed: (){

            },
          child: Icon(Icons.play_circle_outline,color: Colors.redAccent,size:40.0)
        ),
        RaisedButton(
          onPressed: (){

          },
          child:  Icon(Icons.playlist_play,color: Colors.black,size:40.0,),
        )

      ],
    );

    var homeWarp=new Stack(
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
              padding:prefix1.EdgeInsets.all(5.0),
              decoration: BoxDecoration(color: Colors.white70),
              child: playPanel
          ),
        ),
      ],
    );


    return WillPopScope(
        onWillPop: _exit,
        child:Material(
          color:Colors.redAccent,
            child: Container(
              margin:EdgeInsets.fromLTRB(0,MediaQueryData.fromWindow(window).padding.top,0,0),
              color:Colors.white,
              child: homeWarp,
            ),
      )
    );
  }
}