/*
*搜索页
 */

import 'package:flutter/material.dart';
import 'package:flutter_vmusic/conf/router.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter_vmusic/utils/tool.dart';

import 'package:flutter_vmusic/conf/api.dart';

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

class _VideoPage extends State<VideoPage> with SingleTickerProviderStateMixin{


  //歌单详情
  Map videoDetail =  new Map();

  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败



  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {

    });




  }



  //获取数据
  void getData(complete) async{
    var status = 0;
    //热搜榜详细列表
//    await  searchHot((res){
//      hotRankLists=res['data'];
//    },(err){
//      status = 2;
//      print(err);
//    });
    complete(status);
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
    Widget appNav = PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          bottom: PreferredSize(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: 40.0,
                child: Material(
                  color: Colors.white,
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
                          icon: Icon(Icons.arrow_back, color: Colors.black,
                              size: 25.0),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child:
                           Text('视频详情')

                      ),
                      Expanded(
                          flex: 1,
                          child:Visibility(
                              child:IconButton(
                                onPressed: () => {

                                },
                                color: Colors.redAccent,
                                icon: Icon(Icons.more_vert, color: Colors.black, size: 25.0),

                              ),
                            visible:false,
                          )
                      )
                    ],
                  ),
                ),

              )
          ),
        )
    );


    //主内容区
    Widget mainWarp=  new Stack(
        alignment:Alignment.bottomCenter,
        children: <Widget>[

        ]

    );


    //主内容区
    return  Material(
        color:Colors.white,
        child:SafeArea(
          child:Scaffold(
                backgroundColor:Colors.white,
                appBar:appNav ,
                body:Container(child:mainWarp)
            ),
          )
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}
