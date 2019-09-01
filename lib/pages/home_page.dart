import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';



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
  var playStatus=false;
  AudioPlayer audioPlayer = new AudioPlayer();

  Future<void> changePlay() async{
    int result = !playStatus?await audioPlayer.play("http://m8.music.126.net/20190902012730/23e89dc6ff4c439def1e152c1a6e192c/ymusic/0408/5353/5152/3bdc628dc3d97e787959f802077d2425.mp3"):await audioPlayer.pause();
    // 告诉Flutter state已经改变, Flutter会调用build()，更新显示
    setState(() {
      if(result==1) {
        playStatus = !playStatus;
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    //导航栏
    //当前播放歌曲

    var playPanel=RawMaterialButton(
      onPressed: (){},
      splashColor:Color(0xff898B8B),
      child:Container(
        width: double.infinity,
        height: 50.0,
        padding:EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.white70),
        child:  new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding:EdgeInsets.fromLTRB(4.0,0,5.0,0),
              child: CircleAvatar(
                radius:20,
                backgroundImage:  NetworkImage('https://p3.music.126.net/CjGoliP3xOB0gcCUaeTTBg==/109951163375727336.jpg?param=300y300'),
              ) ,),

            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('只要平凡-我不是药神', overflow: TextOverflow.ellipsis,style:TextStyle(),),
                    Text('张杰&张碧晨',style:TextStyle(color:Colors.black45,fontSize:12.0,)),
                  ],
                )
            ),
            IconButton(
                padding:EdgeInsets.all(0.0),
                splashColor:Color(0xff898B8B),
                onPressed: (){
                  changePlay();

                },
                icon: Icon(playStatus==false?Icons.play_circle_outline:Icons.pause_circle_outline,color: Colors.redAccent,size:40.0)
            ),
            IconButton(
              padding:EdgeInsets.all(0.0),
              splashColor:Color(0xff898B8B),
              onPressed: (){

              },
              icon:  Icon(Icons.playlist_play,color: Colors.black,size:40.0),
            )

          ],
        ),
      ),

    );

    var homeWarp=new Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color:Colors.white,
          child: Center(
            child:Text('vmusic',style:TextStyle(fontSize:30.0,fontWeight:FontWeight.bold)),
          )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child:playPanel
        ),
      ],
    );


    return WillPopScope(
        onWillPop: _exit,
        child:Material(
            child: Container(
              margin:EdgeInsets.fromLTRB(0,MediaQueryData.fromWindow(window).padding.top,0,0),
              color:Colors.white,
              child: homeWarp,
            ),
      )
    );
  }
}