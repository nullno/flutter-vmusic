/*
视频模块
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_vmusic/utils/tool.dart';
import 'package:flutter_vmusic/utils/video_player.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';

import 'dart:async';
import 'package:flutter_vmusic/conf/api.dart';

import 'package:flutter_vmusic/conf/router.dart';
import 'package:flutter_vmusic/conf/platform.dart';

class VideoList extends StatefulWidget{

  @override

  State createState() => new _VideoList();

}

class _VideoList extends State<VideoList>{


//  推荐MV数据
  List<dynamic> topList = [];
//  全部MV数据
  List<dynamic> allList = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败
  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Map  loadMore={
         "Text":"----",
         "Page":0,
         "hasMore":true,
         "isScrollBottom":false,
       };

  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();

  @override
  void initState(){
    super.initState();
    if(mounted) {
      addloadMore();
//   数据刷新
      _flashData();
    }
  }

//  全部mv监听加载更多
  addloadMore(){
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent.toStringAsFixed(0);
      var pixel = _scrollController.position.pixels.toStringAsFixed(0);

      if (maxScroll == pixel && loadMore["hasMore"]&&!loadMore["isScrollBottom"]) {

        setState(() {
          loadMore["Text"] = "正在加载中...";
          loadMore["isScrollBottom"]=true;
             getAllMV({"area":'全部',"offset":loadMore['Page']*10},(res){
                  loadMore['hasMore']=res['hasMore'];
                  loadMore['Page']=loadMore['Page']+1;
                  loadMore["isScrollBottom"]=false;
                  res['data'].forEach((aitem)=>{
                    aitem['vurl']=null,
                    allList.add(aitem)
                  });
                },(err){
                  print(err);
                });
        });

      } else if(!loadMore['hasMore']) {
        setState(() {
          loadMore["isScrollBottom"]=true;
           loadMore["Text"] = "~我也是有底线的呦~";
        });
      }
    });
  }

  //  下拉刷新数据
  Future<Null> _flashData() async{
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

    //获取推荐
    await  getPersonalizedMV((res){
        status = 1;
        topList=res['result'];
    },(err){
      status = 2;
      print(err);
    });

    // 获取全部
    await  getAllMV({"area":'全部',"offset":0},(res){
        status = 1;
        loadMore['hasMore']=res['hasMore'];
        loadMore['Page']=1;
        loadMore["isScrollBottom"]=false;
        allList.clear();
        res['data'].forEach((aitem)=>{
          aitem['vurl']=null,
          allList.add(aitem)

      });
    },(err){
      status = 2;
      print(err);
    });

    complete(status);
  }

//获取播放链接
  void midPlayer(mid){
    var result = allList.singleWhere((aitem)=>(aitem['id']==mid),orElse: ()=>(0));

    setState(() {
      result['vurl']=1;
    });
    getMVDetail(mid,(res){
      if(res['code']==200){
          setState(() {
              allList.forEach((aitem)=>{
                  aitem['vurl']=null
              });
              result['vurl']= videoUrl(res['data']['brs']);

          });
      }

    },(err)=>{});

  }


  @override
  Widget build(BuildContext context) {

    Widget _error(BuildContext context, String url, Object error) {
//      print(error);
      return new Center(
        child: Icon(Icons.error,color: Colors.white),
      );
    }

    Widget _loaderImg(BuildContext context, String url) {
      return new Center(
        child:Icon(Icons.image,size:88.0,color:Colors.grey,),
      );
    }

    //推荐
    Widget  topMV = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FixedSizeText('精选MV',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),
        GridView.count(
            primary: false,
            padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.25,
            crossAxisCount: 2,
            shrinkWrap: true,
            children: topList.map((item){
              return  InkWell(
                onTap:()=>{
                  Router.fadeNavigator(context,"/videopage",{'vid':item['id'],'type':0, 'from':'/video'},(res){
                    SYS.systemUI(Colors.transparent,Colors.black,Brightness.dark);
                  })
                },
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: <Widget>[
                            new CachedNetworkImage(
                              placeholder: _loaderImg,
                              errorWidget: _error,
                              imageUrl:item['picUrl'],//item['playlist']['coverImgUrl'],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right:3.0,
                              top:3.0,
                              child:Row(
                                children: <Widget>[
                                  Icon(Icons.play_arrow,color:Colors.white,size:10.0,),
                                  FixedSizeText(tranNumber(item['playCount']),style:TextStyle(color:Colors.white,fontSize:10.0))
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                    Container(
                      padding:EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                      child: FixedSizeText(item['name'],
                          maxLines:1,
                          overflow: TextOverflow.ellipsis,
                          style:TextStyle(fontSize:13.0)),
                    ),

                    FixedSizeText(item['artistName'],
                        maxLines:1,
                        overflow: TextOverflow.ellipsis,
                        style:TextStyle(fontSize:11.0,color:Colors.grey))
                  ],
                )
              );

            }).toList()
        ),

      ],
    );

    //视频片段
    Widget  mvList(List<dynamic>  mvdata){

      return ListView.builder(
        itemCount: mvdata.length,
        shrinkWrap: true,
        primary:false,
        padding:EdgeInsets.all(0.0),
        itemBuilder: (context, i) => Container(
          color:Colors.white,
          width:double.infinity,
          padding:EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
          margin:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: new Stack(
                    alignment:Alignment.center,
                    children: <Widget>[
                      Container(
                        width:double.infinity,
                        color:Colors.black,
                        height:185.0,
                        child:mvdata[i]['vurl']==null||mvdata[i]['vurl']==1?new CachedNetworkImage(
                          imageUrl:mvdata[i]['cover']!=null?mvdata[i]['cover']:"http://p1.music.126.net/l6zOREIvWGNk3L67EkffRw==/1401877337913197.jpg",//item['picUrl'],
                          fit: BoxFit.cover,
                        ):SimpleViewPlayer(mvdata[i]['vurl'], isFullScreen: false),
                      ),
                      mvdata[i]['vurl']==null||mvdata[i]['vurl']==1?Positioned(
                        bottom:3.0,
                        left:3.0,
                        child:Row(
                          children: <Widget>[
                            Icon(Icons.play_arrow,color:Colors.white,size:13.0,),
                            FixedSizeText(tranNumber(mvdata[i]['playCount']),style:TextStyle(color:Colors.white,fontSize:12.0))
                          ],
                        ),
                      ):Container(),
                      mvdata[i]['vurl']==null||mvdata[i]['vurl']==1?Positioned(
                        bottom:3.0,
                        right:3.0,
                        child:Row(
                          children: <Widget>[
                            Icon(Icons.graphic_eq,color:Colors.white,size:13.0,),
                            FixedSizeText(formatDuration(mvdata[i]['duration']),style:TextStyle(color:Colors.white,fontSize:12.0))
                          ],
                        ),
                      ):Container(),
                      mvdata[i]['vurl']==1?CircularProgressIndicator(backgroundColor:Colors.redAccent):mvdata[i]['vurl']==null?Positioned(
                        child:InkWell(
                          onTap:(){
                            midPlayer(mvdata[i]['id']);
                          },
                          child:Icon(Icons.play_arrow,color:Colors.white70,size:45.0,),
                        ),
                      ):Container()
                    ],
                  )
              ),
              Material(
                  color:Colors.white,
                  child:InkWell(
                    highlightColor:Colors.transparent,
                    onTap:(){
                      setState(() {
                        mvdata[i]['vurl']=null;
                      });
                      Router.fadeNavigator(context,"/videopage",{'vid':mvdata[i]['id'],'type':0, 'from':'/video'},(res){
                        SYS.systemUI(Colors.transparent,Colors.black,Brightness.dark);
                      });
                    },
                    child:Padding(
                      padding:EdgeInsets.only(top:10.0,bottom:10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex:7,
                            child:Container(
                                margin:EdgeInsets.fromLTRB(0.0,5.0,0.0,5.0),
                                width:Adapt.screenW(),
                                child:FixedSizeText(mvdata[i]['name']+'---'+mvdata[i]['artistName'],
                                    maxLines:2,
                                    overflow: TextOverflow.ellipsis,
                                    style:TextStyle(fontSize:14.0,height:1.2))),
                          ),
                          Icon(Icons.send,color:Colors.grey,size:15.0,)
                        ],
                      ),
                    ),

                  )
              )

            ],
          ),
        )
      );

    }

    //全部
    Widget  allMV = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
       Container(
        color:Colors.white,
        padding:EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 2.0),
        child:  Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FixedSizeText('全部',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),

          ],
        ),
      ),
        mvList(allList)

      ],
    );

    return  Material(

        child:loadState!=1?Center(child:loadState==0?Loading(indicator: LineScalePulseOutIndicator(), size: 50.0):Icon(Icons.cloud_off,size:40.0,)):RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _flashData, // onRefresh 参数是一个 Future<Null> 的回调
          child:  ListView(
            controller: _scrollController,
//            primary: true,
            physics: const BouncingScrollPhysics(),
            padding:const EdgeInsets.fromLTRB(0.0,0.0,0.0,60.0),
            children: <Widget>[
              Container(
                color:Colors.white,
//                margin:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                padding:EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                child: topMV,
              ),
              Container(
                margin:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                padding:EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: allMV,
              ),
              Visibility(
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        loadMore["hasMore"]?Container(
                          width:15.0,
                          height:15.0,
                          margin:EdgeInsets.all(5.0),
                          child:Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
                        ):Container(),
                        FixedSizeText(loadMore["Text"],textAlign:TextAlign.center,style:TextStyle(height:1,fontSize:12.0))
                      ],
                    ),
                visible: loadMore["isScrollBottom"],
              )
            ],
          ),
        )


    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}