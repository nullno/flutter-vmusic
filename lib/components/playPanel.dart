/*
播放面板
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';

import 'package:flutter_vmusic/conf/appsate.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_vmusic/conf/router.dart';
import 'package:flutter_vmusic/conf/platform.dart';

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

  AudioPlayer audioPlayer = AppState.player['audioPlayer'] ;

      void initState() {
        super.initState();

      }

      //播放歌曲
      void playSong(url) async{
        print(url);
        int result = await audioPlayer.play(url.replaceAll('http:', 'https:'));
        if(result==1) {
          setState(() {
            AppState.player['playStatus']=true;

          });
        }
      }
//暂停播放
  void pauseSong() async{
    int result = await audioPlayer.pause();
    if(result==1) {
      setState(() {
        AppState.player['playStatus']=false;
      });
    }
  }

@override
  Widget build(BuildContext context) {
     return RawMaterialButton(
    onPressed: (){
      Router.fadeNavigator(context,"/playerpage",{'id':AppState.player['id'],'from':'/panel'},(res){
        SYS.systemUI(Colors.transparent,Colors.black,Brightness.dark);
      });
    },
    splashColor:Color(0xff898B8B),
    child:Container(
      width: double.infinity,
      height: 50.0,
      padding:EdgeInsets.all(5.0),
      decoration: BoxDecoration(color:Color.fromRGBO(255, 255, 255, 0.95)),
      child:  new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:EdgeInsets.fromLTRB(4.0,0,5.0,0),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:Container(
                height:40.0,
                width:40.0,
                color:Colors.grey,
                child: new CachedNetworkImage(
                  imageUrl:AppState.player['face'],//item['picUrl'],
                ),
              )
            ) ,),

          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FixedSizeText(AppState.player['name'], overflow: TextOverflow.ellipsis,style:TextStyle(fontSize:13.0),),
                  FixedSizeText(AppState.player['singer'],style:TextStyle(color:Colors.black45,fontSize:11.0)),
                ],
              )
          ),
          IconButton(
              padding:EdgeInsets.all(0.0),
              splashColor:Color(0xff898B8B),
              onPressed: (){
                if(!AppState.player['playStatus']){
                  playSong(AppState.player['url']);
                }else{
                  pauseSong();
                }

              },
              icon: Icon( AppState.player['playStatus']==false?Icons.play_circle_outline:Icons.pause_circle_outline,color: Colors.black,size:40.0)
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