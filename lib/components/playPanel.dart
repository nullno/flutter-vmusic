/*
播放面板
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class PlayPanel extends StatefulWidget{
  final Map params;
  PlayPanel({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _PlayPanel createState() => _PlayPanel();
}

class _PlayPanel extends State<PlayPanel>{
      var playStatus=false;
      AudioPlayer audioPlayer = new AudioPlayer();

      Future<void> changePlay() async{
          int result = !playStatus?await audioPlayer.play("https://source.nullno.com/images/mgdts.mp3"):await audioPlayer.pause();
          // 告诉Flutter state已经改变, Flutter会调用build()，更新显示
           setState((){
              if(result==1) {
                 playStatus = !playStatus;
               }
              });
      }
@override
  Widget build(BuildContext context) {
     return RawMaterialButton(
    onPressed: (){},
    splashColor:Color(0xff898B8B),
    child:Container(
      width: double.infinity,
      height: 50.0,
      padding:EdgeInsets.all(5.0),
      decoration: BoxDecoration(color:Color.fromRGBO(255, 255, 255, 0.95)),
      child:  new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding:EdgeInsets.fromLTRB(4.0,0,5.0,0),

            child: CircleAvatar(
              radius:20,
              backgroundColor:Colors.black45,
              backgroundImage:  NetworkImage('https://p3.music.126.net/kVwk6b8Qdya8oDyGDcyAVA==/1364493930777368.jpg?param=300y300'),
            ) ,),

          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('来自天堂的魔鬼', overflow: TextOverflow.ellipsis,style:TextStyle(),),
                  Text('G.E.M.邓紫棋--新的心跳',style:TextStyle(color:Colors.black45,fontSize:12.0)),
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
  }
}