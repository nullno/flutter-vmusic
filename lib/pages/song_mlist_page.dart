/*
*歌单详情
 */

import 'package:flutter/material.dart';
import 'package:flutter_vmusic/utils/tool.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter_vmusic/conf/api.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';

import 'package:flutter_vmusic/components/playPanel.dart';

class SongMenuList extends StatefulWidget{
  final Map params;
  SongMenuList({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _SongMenuList createState() => _SongMenuList();
}

class _SongMenuList extends State<SongMenuList> with SingleTickerProviderStateMixin{

  //顶部标题
  int topTitleStatus = 0;
  //歌单详情
  Map songDetail =  new Map();
  List<dynamic> songLists = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败
  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeySong = new GlobalKey<RefreshIndicatorState>();
  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();



  @override
  void initState() {
    super.initState();
    changTitle();

    _flashData();

  }
//  滑动切换标题
  changTitle(){
    _scrollController.addListener(() {
      var pixel = _scrollController.position.pixels;
      if (pixel >200) {
        setState(() {
          topTitleStatus=1;
        });
      } else  if(topTitleStatus!=0){
        setState(() {
          topTitleStatus=0;
        });
      }
    });
  }

  //  刷新获取数据
  Future<Null> _flashData(){
    final Completer<Null> completer = new Completer<Null>();

    getData((status){
      setState(() {
        loadState=status;
        completer.complete(null);
      });
    });


    return completer.future;
  }

  //获取数据
  void getData(complete) async{
    var status = 0;

    // 获取推荐歌单
    await  getSongDetail({"id":widget.params['id']},(res){

      songDetail=res['playlist'];
      songLists=res['playlist']['tracks'];

    },(err){
      status = 2;
      print(err);
    });

    complete(status);
  }


  @override
  Widget build(BuildContext context) {

    Widget _loaderImg(BuildContext context, String url) {
      return new Center(
        widthFactor:12.0,
        child:Loading(indicator: LineScalePulseOutIndicator(), size: 50.0),
      );
    }

    //播放面板
    final mPlayPanel = PlayPanel();
    //顶部导航
    Widget appNav =PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child:AppBar(
        backgroundColor:topTitleStatus==1?Colors.white:Colors.black,
        elevation: 0,
        brightness:topTitleStatus==1?Brightness.light:Brightness.dark,
        bottom:PreferredSize(
            child:Container(
              color:topTitleStatus==1?Colors.white:Colors.black,
              width: double.infinity,
              height:40.0,
              child:Material(
                color:Colors.transparent,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:IconButton(
                        onPressed: (){
                                Navigator.pop(context);
                        },
                        icon:Icon(Icons.arrow_back,color: topTitleStatus==0?Colors.white:Colors.black,size:25.0),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child:Container(
                        alignment:Alignment.centerLeft,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FixedSizeText(topTitleStatus==1?songDetail['name']:"歌单",maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:topTitleStatus==0?Colors.white:Colors.black),),
                            FixedSizeText( songDetail.isEmpty?"Loading...":songDetail['description'],maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.grey,fontSize:10.0),),
                          ],
                        ),

                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child:IconButton(
                          onPressed: (){
                                   setState(() {

                                   });
                          },
                          color:Colors.redAccent,
                          icon:Icon(Icons.more_vert,color: topTitleStatus==0?Colors.white:Colors.black,size:25.0),

                        )
                    )
                  ],
                ),
              ),


        )
    ),
      )
    );

    //头部信息
    Widget headInfo= Container(
            height:250.0,
            color:Colors.black,
            child:Stack(
              children: [
                new CachedNetworkImage(
                  placeholder: _loaderImg,
                  imageUrl: songDetail.isEmpty?"":songDetail['coverImgUrl'],//item['picUrl'],
                  fit: BoxFit.cover,
                  width:double.infinity,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: new Container(
                    color:Colors.white.withOpacity(0.0),
                   width: 500,
                  ),
                ),
                Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
                songDetail.isEmpty?new Center(
                  widthFactor:12.0,
                  child:Loading(indicator: LineScalePulseOutIndicator(), size: 50.0),
                ):Column(
                  children: <Widget>[
                    Container(
                      padding:EdgeInsets.all(15.0),
                      height:180.0,
                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:
                              Container(
                                child:Stack(
                                  children: <Widget>[
                                    new CachedNetworkImage(
                                      imageUrl:songDetail['coverImgUrl'],//item['picUrl'],
                                      fit: BoxFit.cover,
                                      width:double.infinity,
                                    ),
                                    Positioned(
                                      top:3.0,
                                      right:3.0,
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.play_arrow,color:Colors.white,size:12.0,),
                                          FixedSizeText(tranNumber(songDetail['playCount']),style:TextStyle(color:Colors.white,fontSize:12.0,shadows: <Shadow>[
                                            Shadow(color: Colors.black,blurRadius:1.0, offset: Offset(1, 1))
                                          ],))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child:Container(
                              padding:EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                              height:double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FixedSizeText(songDetail['name'],maxLines:2,overflow:TextOverflow.ellipsis, style:TextStyle(fontSize:20.0,color:Colors.white,shadows: <Shadow>[
                                    Shadow(color: Colors.black,blurRadius:5.0, offset: Offset(2, 5))
                                  ],)),
                                  FixedSizeText(songDetail['description'],maxLines:3,overflow:TextOverflow.ellipsis, style:TextStyle(fontSize:10.0,color:Colors.white60)),
                                  Container(
                                      margin:EdgeInsets.fromLTRB(0, 20.0,0.0, 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Container(
                                              width:30.0,
                                              height:30.0,
                                              child: new CachedNetworkImage(
                                                imageUrl: songDetail.isEmpty?"":songDetail['creator']['avatarUrl'],//item['picUrl'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:EdgeInsets.all(5),
                                            child:FixedSizeText(songDetail.isEmpty?"":songDetail['creator']['nickname'],maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(fontSize:12.0,color:Colors.white)),
                                          ),

                                        ],
                                      )
                                  ) ,
                                ],
                              )  ,
                            ),
                          ),

                        ],

                      ),
                    ),
                    Container(
                      padding:EdgeInsets.fromLTRB(30.0,0.0,30.0,0.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: (){},
                          child:Column(
                            children: <Widget>[
                              Icon(Icons.insert_comment,color:Colors.white60,size:30.0),
                              FixedSizeText(tranNumber(songDetail['commentCount']),style:TextStyle(fontSize:12.0,color:Colors.white60))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child:Column(
                            children: <Widget>[
                              Icon(Icons.share,color:Colors.white60,size:30.0),
                              FixedSizeText(tranNumber(songDetail['shareCount']),style:TextStyle(fontSize:12.0,color:Colors.white60))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child:Column(
                            children: <Widget>[
                              Icon(Icons.cloud_download,color:Colors.white60,size:30.0),
                              FixedSizeText("下载",style:TextStyle(fontSize:11.0, color:Colors.white60))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child:Column(
                            children: <Widget>[
                              Icon(Icons.check_circle_outline,color:Colors.white60,size:30.0),
                              FixedSizeText("多选",style:TextStyle(fontSize:11.0, color:Colors.white60))
                            ],
                          ),
                        ),

                      ],
                     ),
                    )
                  ],
                ),

              ],
            ),


    );

    //歌曲列表
    Widget songs=Container(
      color:Colors.transparent,
      child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                padding: EdgeInsets.fromLTRB(0.0,15.0,0.0,50.0),
                constraints: BoxConstraints(
                  minHeight: 450,
                ),
                  color:Colors.white,
                  child:songDetail.isEmpty?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width:15.0,
                        height:15.0,
                        margin:EdgeInsets.all(5.0),
                        child:Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
                      ),
                      FixedSizeText("读取歌单中...",textAlign:TextAlign.center,style:TextStyle(height:1,fontSize:12.0))
                    ],
                  ): Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child:SizedBox(
                          height:35.0,
                          child:FlatButton.icon(onPressed: (){}, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22.0))),highlightColor:Colors.transparent, splashColor:Colors.black12, icon: Icon(Icons.play_circle_outline,color:Colors.black,size:35.0,), label:FixedSizeText("播放全部(${songDetail['tracks'].length}首)", style:TextStyle(color:Colors.black,fontSize:14.0),)) ,
                        ) ,
                      ),
                      Divider(
                        height:28.0,
                      ),
                      Column(
                        children: songLists.asMap().keys.map((index){
                          return  Material(
                            color:Colors.transparent,
                            child: InkWell(
                              onTap: (){},

                              child:  Container(
                                margin:EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
                                padding:EdgeInsets.fromLTRB(15.0,0.0,15.0,0.0) ,
                                child:  Row(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: FixedSizeText((index+1).toString(),textAlign:TextAlign.left,style:TextStyle(color:Colors.grey,fontSize:20.0)),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child:Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: <Widget>[
                                          FixedSizeText(songLists[index]['name'],maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.black,fontSize:13.0)),
                                          FixedSizeText(songLists[index]['ar'][0]['name'],maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(color:Colors.grey,fontSize:12.0)),
                                        ],
                                      ) ,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child:Visibility(
                                          child: Align(
                                            alignment:Alignment.topRight,
                                            child:  InkWell(onTap: (){},child:Icon(Icons.music_video,color:Colors.redAccent,)),
                                          ),
                                          visible:songLists[index]['mv']>0,
                                        )
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child:Align(
                                          alignment:Alignment.topRight,
                                          child: InkWell(onTap: (){}, child:Icon(Icons.more_vert,color:Colors.grey,)),
                                        )
                                    ),
                                  ],

                                ),
                              ),
                            ),
                          );

                        }).toList(),
                      ),
                      Center(
                        child:FixedSizeText('~没有了呦~',textAlign:TextAlign.center,style:TextStyle(color:Colors.grey,fontSize:12.0),)
                      )

                    ],
                  )
            ),
          ),
    );


    //主内容区
    Widget mainWarp=RefreshIndicator(
      key: _refreshIndicatorKeySong,
      onRefresh: _flashData,
      child: new Stack(
        children: <Widget>[
          ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              headInfo,
              songs
            ],
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child:mPlayPanel
      ),
      ]

     )
    );


    //主内容区
    return  Material(
      color:Colors.white,
      child:
            Scaffold(
                appBar:appNav ,
                body:mainWarp
            ),


    );
  }
  @override
  void dispose() {

    _scrollController.dispose();
    super.dispose();
  }

}
