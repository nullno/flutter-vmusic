/*
*搜索页
 */

import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;

import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:flutter_vmusic/utils/tool.dart';

import 'package:flutter_vmusic/conf/api.dart';

import 'package:flutter_vmusic/conf/platform.dart';


class PlayerPage extends StatefulWidget{
  final Map params;
  PlayerPage({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _PlayerPage createState() => _PlayerPage();
}

class _PlayerPage extends State<PlayerPage> with SingleTickerProviderStateMixin{


  //歌单详情
  Map songDetail =  new Map();

  //加载状态
  int loadState = 0; //0 加载中  1加载完成  2 失败

  @override
  void initState() {
    super.initState();

    SYS.hideBar();


    //歌曲详情
    getSongDetail(widget.params['id'],(res){
       setState(() {
         songDetail = res['songs'][0];
       });

    },(err){
      loadState=2;
    });
    //歌曲链接
//    getSongUrl(widget.params['id'],(res){
//        setState(() {
//
//        });
//    },(err){
//    loadState=2;
//    });

  }



  @override
  Widget build(BuildContext context) {
    //顶部导航
    Widget appNav = Offstage(
      child:SafeArea(child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: 50.0,
        child: Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child:Visibility(
                    child:IconButton(
                      padding:EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white70,
                          size: 30.0),
                    ),
                    visible:true,
                  )
              ),
              Expanded(
                  flex: 5,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FixedSizeText(songDetail.isNotEmpty?songDetail['name']:'loading...',maxLines:1,overflow:TextOverflow.ellipsis,textAlign:TextAlign.center, style:TextStyle(color:Colors.white),),
                      FixedSizeText(songDetail.isNotEmpty?songDetail['ar'][0]['name']:'loading...',maxLines:1,overflow:TextOverflow.ellipsis,textAlign:TextAlign.center, style:TextStyle(fontSize:12.0, color:Colors.grey),)
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child:Visibility(
                    child:IconButton(
                      onPressed: (){

                      },
                      color: Colors.redAccent,
                      icon: Icon(Icons.more_vert, color: Colors.white70, size: 25.0),

                    ),
                    visible:true,
                  )
              )
            ],
          ),
        ),

      )),
      offstage:false,
    );
    //
    Widget playView= Container(
        decoration:new BoxDecoration(
            image: new DecorationImage(
                image:NetworkImage(songDetail.isNotEmpty?songDetail['al']['picUrl']:'https://p4.music.126.net/PeIyrKa1NL2BUAzw8kcnpQ==/109951164144255354.jpg?param=200y200'),
                fit:BoxFit.fill,
            )

        ),
         child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                      child: new Container(
                        color:Colors.black.withOpacity(0.5),
                        width: 500,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black45,
                            Colors.transparent,
                            Colors.black45
                          ],
                        ),
                      ),
                      child:Center(
                        child: Container(
                              height:250,width:250.0,
                              decoration:new BoxDecoration(

                              image: new DecorationImage(
                                  image:AssetImage('assets/image/disc.png'),

                                    fit:BoxFit.fill,
                              )
                              ),
                          child:Padding(
                            padding:EdgeInsets.all(50.0),
                            child:  ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child:Image.network(songDetail.isNotEmpty?songDetail['al']['picUrl']:'')
                            )
                          ),

                           ),
                      ),
                    ),
          ])
    );

    Widget playControl = Container(
          height:150.0,
//          color:Colors.black,
          padding:EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.end,
            children: <Widget>[
              Row(),
              Padding(padding: EdgeInsets.only(
                top:10,bottom:10,),
                child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: FixedSizeText('05:03',maxLines:1,textAlign:TextAlign.center, style:TextStyle(color:Colors.white54,fontSize:12.0),),
                  ),
                  Expanded(
                    flex:5,
                    child:Container(
                        color:Colors.transparent,
                        height:8,
                        child:Stack(
                          alignment:Alignment.centerLeft,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:Container(
                                width:double.infinity,
                                height:2,
                                color:Colors.white54,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:Container(
                                width:200,
                                height:2,
                                color:Colors.red,
                              ),
                            ),
                            Positioned(
                              left:200,
                              child:ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    width:8.0,
                                    height:8.0,
                                    color:Colors.red,
                                  )
                              ),
                            )
                          ],
                        )
                    ),

                  ),
                  Expanded(
                    flex:1,
                    child: FixedSizeText('06:03',maxLines:1,textAlign:TextAlign.center, style:TextStyle(color:Colors.white54,fontSize:12.0),),
                  ),
                ],
              )
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                        padding:EdgeInsets.all(0.0),
                              onPressed: () {

                              },
                              icon: Icon(Icons.repeat, color: Colors.white24,
                                  size: 30.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.skip_previous, color: Colors.white54,
                        size: 30.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.play_circle_outline, color: Colors.white70,
                        size: 50.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.skip_next, color: Colors.white54,
                        size: 30.0),
                  ),
                  IconButton(
                    padding:EdgeInsets.all(0.0),
                    onPressed: () {

                    },
                    icon: Icon(Icons.playlist_play, color: Colors.white24,
                        size: 30.0),
                  ),
                ],
              ),
            ],
          ),
    );

    //主内容区
    Widget mainWarp= new Stack(
        alignment:Alignment.topCenter,
        children: <Widget>[
           playView,
           appNav,
           Align(
             alignment: Alignment.bottomCenter,
             child: playControl,
           )
        ]

    );

    //主内容区
    return  Material(color:Colors.white, child:mainWarp);
  }
  @override
  void dispose() {
    super.dispose();
  }

}
