/*
视频模块
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter_vmusic/conf/api.dart';
import 'package:flutter_vmusic/utils/tool.dart';

//import 'package:video_player/video_player.dart';
//import 'package:chewie/chewie.dart';
import 'package:flutter_simple_video_player/flutter_simple_video_player.dart';

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
         "hasMore":true
       };

  //视频控制
//  VideoPlayerController _videoPlayerController;
  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();

  @override
  void initState(){
    super.initState();


    addloadMore();


//   数据刷新
    _flashData();
//    getData((status){
//      setState(() {
//        loadState=status;
//      });
//    });
  }

//  全部mv监听加载更多
  addloadMore(){
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixel = _scrollController.position.pixels;

      if (maxScroll == pixel && loadMore["hasMore"]) {

        print(maxScroll);
        print(pixel);

        setState(() {
          loadMore["Text"] = "正在加载中...";
             getAllMV({"area":'全部',"offset":loadMore['page']*10},(res){
                  loadMore['hasMore']=res['hasMore'];

                  loadMore['page']=loadMore['page']+1;
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

    /*    // 启动一下 [Timer] 在3秒后，在list里面添加一条数据，关完成这个刷新
    new Timer(Duration(seconds: 2), () {
      // 添加数据，更新界面
      // 完成刷新
      completer.complete(null);
    });
     */

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
        loadMore['page']=1;
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


              print(res['data']['brs']);
              if(res['data']['brs'].containsKey("1080")){
                result['vurl']=res['data']['brs']['1080'].replaceAll('http:', 'https:');
               return;
              }
              if(res['data']['brs'].containsKey("720")){
                result['vurl']=res['data']['brs']['720'].replaceAll('http:', 'https:');
                return;
              }
              if(res['data']['brs'].containsKey("480")){
                result['vurl']=res['data']['brs']['480'].replaceAll('http:', 'https:');
                return;
              }
              if(res['data']['brs'].containsKey("240")){
                result['vurl']=res['data']['brs']['240'].replaceAll('http:', 'https:');
                return;
              }
              result['vurl']="https://source.nullno.com/blog/220050677efa8a64c018ef48289ea236a0c11531882000114a12be221fc.mp4";

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
        widthFactor:12.0,
        child:Icon(Icons.hdr_weak,size:75.0,color:Colors.grey,),
      );
    }

    //推荐
    Widget  topMV = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('精选MV',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),
        GridView.count(
            primary: false,
            padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
            crossAxisCount: 2,
            shrinkWrap: true,
            children: topList.map((item){
              return  Column(
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
                                Text(tranNumber(item['playCount']),style:TextStyle(color:Colors.white,fontSize:10.0))
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  Text(item['name'],
                      maxLines:1,
                      overflow: TextOverflow.ellipsis,
                      style:TextStyle(fontSize:13.0,height:1.5)),
                  Text(item['artistName'],
                      maxLines:1,
                      overflow: TextOverflow.ellipsis,
                      style:TextStyle(fontSize:13.0,height:1,color:Colors.grey))
                ],
              );
            }).toList()
        ),

      ],
    );

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
            Text('全部',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),

          ],
        ),
      ),

        Column(
            children: allList.map((item){
              return Container(
                color:Colors.white,
                width:double.infinity,
                padding:EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                margin:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          alignment:Alignment.center,
                          children: <Widget>[
                        Container(
                          width:double.infinity,
                          color:Colors.black,
                          height:185.0,
                          child:item['vurl']==null||item['vurl']==1?new CachedNetworkImage(
                              placeholder: _loaderImg,
                              imageUrl:item['cover']!=null?item['cover']:"http://p1.music.126.net/l6zOREIvWGNk3L67EkffRw==/1401877337913197.jpg",//item['picUrl'],
                              fit: BoxFit.cover,
                            ):SimpleViewPlayer(item['vurl'], isFullScreen: false,),
                        ),
                            item['vurl']==null||item['vurl']==1?Positioned(
                              bottom:3.0,
                              left:3.0,
                              child:Row(
                                children: <Widget>[
                                  Icon(Icons.play_arrow,color:Colors.white,size:13.0,),
                                  Text(tranNumber(item['playCount']),style:TextStyle(color:Colors.white,fontSize:12.0))
                                ],
                              ),
                            ):Container(),
                            item['vurl']==1?CircularProgressIndicator(backgroundColor:Colors.redAccent):item['vurl']==null?Positioned(
                              child:InkWell(
                                onTap:(){
                                  midPlayer(item['id']);

                                 },
                                child:Icon(Icons.play_arrow,color:Colors.white70,size:45.0,),
                              ),
                            ):Container()
                          ],
                        )
                    ),
                    Container(
                      margin:EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0),
                      child:Text(item['name'],
                            maxLines:2,
                            overflow: TextOverflow.ellipsis,
                            style:TextStyle(fontSize:16.0,height:1.2)))

                  ],
                ),
              );

            }).toList()
        ),

      ],
    );

    return  Material(

        child:loadState!=1?Center(child:loadState==0?CircularProgressIndicator(
          backgroundColor:Colors.redAccent,
        ):Icon(Icons.cloud_off,size:40.0,)):RefreshIndicator(
          color:Colors.deepPurple,
          key: _refreshIndicatorKey,
          onRefresh: _flashData, // onRefresh 参数是一个 Future<Null> 的回调
          child:  ListView(
            controller: _scrollController,
//            primary: true,
            physics: const AlwaysScrollableScrollPhysics(),
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
              Text(loadMore["Text"],textAlign:TextAlign.center,style:TextStyle(height:1),)
            ],
          ),
        )


    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}