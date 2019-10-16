/*
*搜索页
 */

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_vmusic/conf/router.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter_vmusic/utils/tool.dart';

import 'package:flutter_vmusic/conf/api.dart';


import 'package:flutter_vmusic/utils/video_player.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:flutter_vmusic/conf/platform.dart';



class VideoPage extends StatefulWidget{
  final Map params;
  VideoPage({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _VideoPage createState() => _VideoPage();
}

class _VideoPage extends State<VideoPage> {


  //歌单详情
  Map videoDetail =  new Map();

  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败

  bool barshow=false; //导航显示状态


  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
      SYS.hideTopBar();
      print(widget.params);


    if(widget.params['type']==0){
      getMVDetail(widget.params['vid'],(res){
        print(res);
          setState(() {
            res['data']['vurl'] =videoUrl(res['data']['brs']);
            videoDetail=res['data'];
          });
        });
    }
    if(widget.params['type']==1){
      getVideoDetail(widget.params['vid'],(res){
          setState(() {

            videoDetail=res['data'];
          });
          getVideoUrl(widget.params['vid'],(resv){
            setState(() {
              if(resv['urls'].length>0){
                videoDetail['vurl'] = resv['urls'][0]['url'].replaceAll('http:', 'https:');


              }
            });
          });
      });
    }




  }




  @override
  Widget build(BuildContext context) {
    Widget _loaderImg(BuildContext context, String url) {
      return new Center(
        widthFactor: 12.0,
        child: Loading(indicator: LineScalePulseOutIndicator(), size: 50.0),
      );
    }

    //顶部导航
    Widget appNav = Visibility(
      child: SafeArea(
          child:  Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 40.0,
            child: Material(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white,
                          size: 25.0),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: FixedSizeText(videoDetail.isNotEmpty?widget.params['type']==1?videoDetail['title']:videoDetail['name']:'loading...',maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.white),)
                  ),
                  Expanded(
                      flex: 1,
                      child:Visibility(
                        child:IconButton(
                          onPressed: () => {

                          },
                          color: Colors.redAccent,
                          icon: Icon(Icons.more_vert, color: Colors.white, size: 25.0),

                        ),
                        visible:false,
                      )
                  )
                ],
              ),
            ),

          )
      ),
      visible:barshow,
    );

    Widget viewPanel = ListView(
      children: <Widget>[
        InkWell(onTap:(){
              setState(() {
                barshow=!barshow;
                !barshow? SYS.hideTopBar():SYS.systemUI(Colors.transparent,Colors.black,Brightness.light);
              });
          },
            child: Container(
                width:double.infinity,
                color:Colors.black,
                height:230,
                child:videoDetail.isNotEmpty && videoDetail.containsKey("vurl") ?SimpleViewPlayer(videoDetail['vurl'], isFullScreen: false,):
                Center(
                     child:videoDetail.containsKey("coverUrl") || videoDetail.containsKey("cover")?Container(
                       width:double.infinity,
                         decoration:new BoxDecoration(
                           image: new DecorationImage(
                               image:NetworkImage(widget.params['type']==1?videoDetail['coverUrl']:videoDetail['cover'])
                               )

                         ),

                            ): Center(
                       child:SizedBox(
                           width:40.0,
                           height:40.0,
                           child: CircularProgressIndicator(backgroundColor:Colors.redAccent)),
                     )
                      )
            )
        ),
        videoDetail.isNotEmpty?Container(
          padding:EdgeInsets.all(15.0),
          child:  FixedSizeText(widget.params['type']==1?videoDetail['title']:videoDetail['name'],style:TextStyle(color:Colors.black)),
        ):Container(),
      ],
    );


    //主内容区
    Widget mainWarp=  new Stack(
        alignment:Alignment.topCenter,
        children: <Widget>[
          viewPanel,
          appNav
        ]

    );


    //主内容区s
    return  Material(
          color:Colors.white,
          child:mainWarp,
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}
