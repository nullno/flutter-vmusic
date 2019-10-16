/*
推荐模块
 */
import 'package:flutter/material.dart';
import 'package:flutter_vmusic/conf/router.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

//import 'package:flutter/painting.dart';
import 'package:flutter_vmusic/conf/api.dart';
import 'package:flutter_vmusic/utils/tool.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_indicator.dart';



class Find extends StatefulWidget{

  @override

  State createState() => new _Find();

}

class _Find extends State<Find> with SingleTickerProviderStateMixin{




//  banner数据
  List<dynamic> adList = [];
 // 热歌榜数据
  List<dynamic> songRanks = [];
 //歌单
  List<dynamic> songLists = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败

  TabController AdController;//tab控制器
  int _AdcurrentIndex = 0; //选中下标

  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState(){
     super.initState();

//    数据刷新
//     getData((status){
//       setState(() {
//       loadState=status;
//       });
//     });
    _flashData();
  }
  //广告图初始化controller并添加监听
  void _adController(){
    AdController = TabController(initialIndex:0,length:adList.length, vsync: this);
    AdController.addListener((){
      if (AdController.index.toDouble() == AdController.animation.value) {
        //赋值 并更新数据
        this.setState(() {
          _AdcurrentIndex = AdController.index;
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
   //banner
  await  getBanner((res){
       status = 1;
       adList = res['banners'];
       _adController();
     },(err){
      status = 2;
       print(err);
     });

   //获取热歌榜
await  getRank((res){
       status = 1;
       songRanks=res;
   },(err){
     status = 2;
     print(err);
   });

   // 获取推荐歌单
await   getPersonalizedSongList((res){
        status = 1;
        songLists=res['result'];
    },(err){
      status = 2;
      print(err);
    });

   complete(status);
 }


  @override
  Widget build(BuildContext context) {

    Widget _loader(BuildContext context, String url) {
      return new Center(
        widthFactor:12.0,
        child: CircularProgressIndicator(
          backgroundColor:Colors.white,
        ),
      );
    }

    Widget _error(BuildContext context, String url, Object error) {
//      print(error);
      return new Center(
        child: Icon(Icons.error,color: Colors.white),
      );
    }

    Widget _loaderImgBlank(BuildContext context, String url) {
      return new Center(
        widthFactor:12.0,
        child:Icon(Icons.image,size:158,color: Colors.grey,)
      );
    }

    //广告图
    Widget slideBanner = TabBarView(
      controller: AdController,
      children:  adList.map((item){
        return Container(
            margin:EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child:Container(
              color:Colors.white30,
              child: new CachedNetworkImage(
                placeholder: _loader,
                errorWidget: _error,
                imageUrl: item['imageUrl'],//item['imageUrl'],
                fit: BoxFit.cover,
              )
            ),
          )
        );
      }).toList()
    );

    //热歌榜
    Widget  songRank = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FixedSizeText('热歌榜',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),
        GridView.count(
          primary: false,
          padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          crossAxisCount: 6,
          shrinkWrap: true,
          children: songRanks.map((item){
            return  Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Stack(
                      children: <Widget>[
                          InkWell(
                          onTap: (){
                            Router.fadeNavigator(context,"/songmenulist",{'id':item['playlist']['id'],'from':'/find'},(res){});
                           },
                          child: new CachedNetworkImage(
                                        imageUrl:item['playlist']['coverImgUrl'],//item['playlist']['coverImgUrl'],
                                        fit: BoxFit.cover,
                                      ),
                          )
                       /* Positioned(
                          left:20.0,
                          bottom:3.0,
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.play_arrow,color:Colors.white,size:10.0,),
                              FixedSizeText(tranNumber(item['playlist']['playCount']),style:TextStyle(color:Colors.white,fontSize:10.0))
                            ],
                          ),
                        )*/
                      ],
                    )
                ),
               /* FixedSizeText(item['playlist']['name'],
                    maxLines:1,
                    overflow: TextOverflow.ellipsis,
                    style:TextStyle(fontSize:13.0,height:1.5))*/
              ],
            );
          }).toList()
        ),

      ],
    );

    //歌单
    Widget  songList = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FixedSizeText('推荐歌单',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                 child:  Material(
                   color:Colors.white,
                   child: InkWell(
                    onTap: (){
                      Router.fadeNavigator(context,"/songmenu",{'des':'我是首页进来的555','from':'/find'},(res){});
                    },
                     highlightColor:Colors.grey,

                  child:Icon(Icons.more_horiz),
                ),
              )
            ),

          ],
        ),

        GridView.count(
            primary: false,
            padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
            crossAxisCount: 2,
            shrinkWrap: true,
            children: songLists.map((item){
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Router.fadeNavigator(context,"/songmenulist",{'id':item['id'],'from':'/find'},(res){});
                    },
                    child:ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: <Widget>[
                            new CachedNetworkImage(
                              placeholder: _loaderImgBlank,
                              errorWidget: _error,
                              imageUrl:item['picUrl'],//item['picUrl'],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top:3.0,
                              right:3.0,
                              child:Row(
                                children: <Widget>[
                                  Icon(Icons.play_circle_outline,color:Colors.white,size:15.0,),
                                  FixedSizeText(tranNumber(item['playCount']),style:TextStyle(color:Colors.white,fontSize:14.0))
                                ],
                              ),
                            )
                          ],
                        )
                    ) ,
                  ),

                  Container(
                    padding:EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                    child:FixedSizeText(item['name'],
                        maxLines:2,
                        overflow: TextOverflow.ellipsis,
                        style:TextStyle(fontSize:13.0,height:1.2)),
                  )

                ],
              );
            }).toList()
        ),

      ],
    );

    return  Material(
//        255, 240,62,57
      child:loadState!=1?Center(child:loadState==0?Loading(indicator: LineScaleIndicator(), size: 50.0):Icon(Icons.cloud_off,size:40.0,)):RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _flashData, // onRefresh 参数是一个 Future<Null> 的回调
        child:  ListView(
          primary: true,
          physics: BouncingScrollPhysics(),
          padding:const EdgeInsets.fromLTRB(0.0,0.0,0.0,60.0),
          children: <Widget>[
            Container(
              height: 150.0,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0, 0.0),
              padding:EdgeInsets.fromLTRB(0, 8.0, 0.0, 8.0),
              color: Colors.white,
              child: slideBanner,
            ),
            Container(
              color:Colors.white,
              margin:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              padding:EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
              child: songRank,
            ),
            Container(
              color:Colors.white,
              margin:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              padding:EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
              child: songList,
            ),
            FixedSizeText('~我也是有底线的呦~',textAlign:TextAlign.center,style:TextStyle(height:2.0,fontSize:12.0),)


          ],
        ),
      )


    );

  }

  @override
  void dispose() {

    AdController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}