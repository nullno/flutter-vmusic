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

  int titleLine= 1;

  // 精彩评论
  List<dynamic> HotCommentList = [];
  //全部评论
  List<dynamic> AllCommentList = [];
  int commentloadStatus = 1; //1加载中 2加载完成 评论


  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
      SYS.hideTopBar();
      print(widget.params);

    if(widget.params['type']==0){
      getMVDetail(widget.params['vid'],(res){
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

    getComment();
  }



  //获取评论
  getComment(){
    if(widget.params['type']==0){
      getMvComment(widget.params['vid'],(res){
        setState(() {
          HotCommentList = res['hotComments'];
          AllCommentList = res['comments'];
          commentloadStatus=2;
        });
      });
    }
    if(widget.params['type']==1){
      getVideoComment(widget.params['vid'],(res){
        setState(() {
          HotCommentList = res['hotComments'];
          AllCommentList = res['comments'];

          commentloadStatus=2;
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
    Widget appNav = Offstage(
      child:SafeArea(child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: 30.0,
        child: Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: IconButton(
                        padding:EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white,
                      size: 25.0),
                )
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

      )),
      offstage:!barshow,
    );

    //视频
    Widget videoPanel = Material(
      child: Container(
          width:Adapt.screenW(),
          color:Colors.black,
          height:200,
          child:videoDetail.isNotEmpty && videoDetail.containsKey("vurl") ?SimpleViewPlayer(videoDetail['vurl'], isFullScreen: false,
              callback:(){
                     setState(() {
                      barshow=!barshow;
                      !barshow? SYS.hideTopBar():SYS.systemUI(Colors.transparent,Colors.black,Brightness.light);
                      });
              }):
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
      ));

//视频信息
    Widget vInfo =  videoDetail.isNotEmpty?Container(
        color:Colors.white,
        padding:EdgeInsets.fromLTRB(15.0,10.0,15.0,5.0),
        margin:EdgeInsets.only(bottom:10.0),
        child:Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex:12,
                      child:Container(

                        child:FixedSizeText(widget.params['type']==1?videoDetail['title']:videoDetail['name'] +'  --'+videoDetail['artistName'],maxLines:3,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.black,fontSize:15,fontWeight:FontWeight.bold)),
                      )

                  ),
                  Expanded(
                    flex:1,
                    child:SizedBox(
                      height:30.0,
                      child:IconButton(padding:EdgeInsets.all(0), icon: Icon(titleLine==1?Icons.arrow_drop_down:Icons.arrow_drop_up,color:Colors.grey,size:30,), onPressed: (){
                        setState((){
                          titleLine=titleLine==1?3:1;
                        });
                      }),
                    ),
                  )
                ],
              ),
              Padding(
                padding:EdgeInsets.only(top:5.0),
                child: FixedSizeText(tranNumber(videoDetail[widget.params['type']==1?'playTime':'playCount'])+'次观看',style:TextStyle(color:Colors.grey,fontSize:13)),
              ),
              Visibility(child:Padding(
                padding:EdgeInsets.only(top:5.0),
                child: FixedSizeText((widget.params['type']==1?tranTimestr(videoDetail['publishTime']):videoDetail['publishTime'])+'发布',style:TextStyle(color:Colors.grey,fontSize:12)),
              ),
                visible:titleLine==3,
              ),
              Visibility(child:Padding(
                padding:EdgeInsets.only(top:5.0),
                child: FixedSizeText(videoDetail['description']!=null&&videoDetail['description']!=''?videoDetail['description']:'',style:TextStyle(color:Colors.grey,fontSize:12)),
              ),
                visible:widget.params['type']==1 && titleLine==3,
              ),

              Container(
                padding:EdgeInsets.fromLTRB(30.0,10.0,30.0,10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: (){},
                      child:Column(
                        children: <Widget>[
                          Icon(Icons.touch_app,color:Colors.black,size:30.0),
                          FixedSizeText(tranNumber(videoDetail[widget.params['type']==1?'praisedCount':'likeCount']),style:TextStyle(fontSize:12.0,color:Colors.black))
                        ],
                      ),
                    ),
//                      InkWell(
//                        onTap: (){},
//                        child:Column(
//                          children: <Widget>[
//                            Icon(Icons.add_box,color:Colors.black,size:30.0),
//                            FixedSizeText(tranNumber(videoDetail['shareCount']),style:TextStyle(fontSize:12.0,color:Colors.black))
//                          ],
//                        ),
//                      ),
                    InkWell(
                      onTap: (){},
                      child:Column(
                        children: <Widget>[
                          Icon(Icons.insert_comment,color:Colors.black,size:30.0),
                          FixedSizeText(tranNumber(videoDetail['commentCount']),style:TextStyle(fontSize:12.0, color:Colors.black))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){},
                      child:Column(
                        children: <Widget>[
                          Icon(Icons.share,color:Colors.black,size:30.0),
                          FixedSizeText(tranNumber(videoDetail['shareCount']),style:TextStyle(fontSize:12.0, color:Colors.black))
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Divider(),
              widget.params['type']==1?
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child:Container(
                          width:40,
                          height:40,
                          child:new CachedNetworkImage(
                            imageUrl:videoDetail['avatarUrl'],//item['picUrl'],
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                    Padding(
                      padding:EdgeInsets.only(left:5),
                      child: FixedSizeText(videoDetail['creator']['nickname'],style:TextStyle(color:Colors.black,fontSize:13)),
                    )

                  ]
              ):Container()
            ]
        )
    ):Container();

 //评论列表
  Widget commentList(List<dynamic> listData){
    return ListView.builder(
        itemCount: listData.length,
        shrinkWrap: true,
        primary:false,
        padding:EdgeInsets.all(0.0),
        itemBuilder: (context, i) =>Material(
                  color:Colors.transparent,
                  child: InkWell(
                      onTap: (){},
                      child:Container(
                        padding:EdgeInsets.only(top:10.0,bottom:10.0),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin:EdgeInsets.fromLTRB(15.0, 0.0, 10, 0),
                              child:ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child:Container(
                                    width:30,
                                    height:30,
                                    child:new CachedNetworkImage(
                                      imageUrl:listData[i]['user']['avatarUrl'],//item['picUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              )
                          ) ,
                          Expanded(
                              flex:7,
                              child: Container(
                                padding:EdgeInsets.only(right:15.0),
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: <Widget>[
                                            FixedSizeText(listData[i]['user']['nickname'],maxLines:1, style:TextStyle(color:Colors.grey,fontSize:12)),
                                            FixedSizeText(tranTimestr(listData[i]['time']),maxLines:1, style:TextStyle(color:Colors.grey,fontSize:9)),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            FixedSizeText(listData[i]['likedCount'].toString(),maxLines:1, style:TextStyle(color:Colors.grey,fontSize:12)),
                                            Icon(Icons.star_border,size:15,)
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:EdgeInsets.only(top:5,bottom:5),
                                      child:FixedSizeText(listData[i]['content'],maxLines:20, style:TextStyle(color:Colors.black,fontSize:13,height:1.2)),
                                    ),
                                    Divider()

                                  ],
                                ) ,
                              )
                          ),
                        ],
                      ),
                    )
                  ),

                  )
    );
  }


//评论
  Widget commentPanel = Container(
      color:Colors.white,
      padding:EdgeInsets.only(top:15.0,bottom: 15.0),
      child: commentloadStatus==2 && AllCommentList.length>0? Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            HotCommentList.length>0?Padding(
              padding:EdgeInsets.only(left:15.0),
              child:FixedSizeText('精彩评论',style:TextStyle(fontSize:15.0,fontWeight:FontWeight.bold,color:Colors.red)),
            ):Container(),
            HotCommentList.length>0?Padding(
              child: Divider(),
              padding:EdgeInsets.fromLTRB(15.0,5.0,15.0,0.0),
            ):Container(),
            HotCommentList.length>0?commentList(HotCommentList):Container(),
            AllCommentList.length>0?Container(
               color: Color(0xFFF2F2F2),
             height:10.0,
            ):Container(),
            AllCommentList.length>0?Container(
              padding:EdgeInsets.only(left:15.0),
              margin:EdgeInsets.only(top:10.0,),
              child:FixedSizeText('全部评论:',style:TextStyle(fontSize:15.0,fontWeight:FontWeight.bold,color:Colors.black)),
            ):Container(),
            AllCommentList.length>0?Padding(
              child: Divider(),
              padding:EdgeInsets.fromLTRB(15.0,5.0,15.0,5.0),
            ):Container(),
            AllCommentList.length>0?commentList(AllCommentList):Container(),
          ],
        ):Container(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Container(
              width:15.0,
              height:15.0,
              margin:EdgeInsets.all(5.0),
              child:Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
            ),
            visible:commentloadStatus==1 ,
          ),
          FixedSizeText(commentloadStatus==1?"努力加载中...":'暂无评论',textAlign:TextAlign.center,style:TextStyle(height:1,fontSize:12.0))
        ],
      ),)

    );


//滑动面板
  Widget viewPanel = Container(
        width:Adapt.screenW(),
        height:Adapt.screenH()-200,
        color: Color(0xFFF2F2F2),
        child:ListView(
          padding:EdgeInsets.all(0.0),
          children: <Widget>[
            vInfo,
            commentPanel
          ],
        )
    );

//主内容区
    Widget mainWarp=  new Stack(
        alignment:Alignment.topCenter,
        children: <Widget>[
          videoPanel,
          appNav,
          Positioned(
            bottom:0,
            child: viewPanel,
          ),
        ]

    );


    //主内容区s
    return Material(child: mainWarp) ;
  }
  @override
  void dispose() {
    super.dispose();
  }

}
