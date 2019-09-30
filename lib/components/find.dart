/*
推荐模块
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter_vmusic/conf/api.dart';

import 'package:flutter_vmusic/utils/tool.dart';


class Find extends StatefulWidget{

  @override

  State createState() => new _Find();

}

class _Find extends State<Find> with SingleTickerProviderStateMixin{

  TabController controller;//tab控制器
  int _currentIndex = 0; //选中下标

//  banner数据
  List<Map> adList = [{'title':'标题1','imgpath':'http://p1.music.126.net/h_G8a9xxeXTmwjcB8mR0pQ==/109951164372410150.jpg','link':''},
                       {'title':'标题1','imgpath':'http://p1.music.126.net/ifxuv3opkDlaljb2BDfT0Q==/109951164372452784.jpg','link':''},
                       {'title':'标题1','imgpath':'http://p1.music.126.net/5l0td3TZQg4pyX8oNdeaqA==/109951164372575001.jpg','link':''},];//tab集合
 // 热歌榜数据
  List<dynamic> songRanks = [];

  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    //广告图初始化controller并添加监听
    controller = TabController(initialIndex:0,length: adList.length, vsync: this);
    controller.addListener((){
      if (controller.index.toDouble() == controller.animation.value) {
        //赋值 并更新数据
        this.setState(() {
          _currentIndex = controller.index;
        });
      }
    });
    _getData();
    getSongList((res){
        print(res);
    },(err){
      print(err);
    });
  }


//  刷新获取数据
  Future<Null> _getData() {
    final Completer<Null> completer = new Completer<Null>();

      getRank((res){
          completer.complete(null);
          setState(() {
                songRanks=res;
                print(res[0]['playlist']['coverImgUrl']);
                print(res[1]['playlist']['coverImgUrl']);
                print(res[2]['playlist']['coverImgUrl']);
          });
      },(err){
        completer.complete(null);
        print(err);
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

    //广告图
    Widget slideBanner = TabBarView(
      controller: controller,
      children:  adList.map((item){
        return Container(
            margin:EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child:Container(
              color:Colors.white12,
              child: new CachedNetworkImage(
                placeholder: _loader,
                errorWidget: _error,
                imageUrl: item['imgpath'],
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
        Text('热歌榜',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),
        GridView.count(
          primary: false,
          padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
          crossAxisCount: 4,
          shrinkWrap: true,
          children: songRanks.map((item){
            return  Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      children: <Widget>[
                        new CachedNetworkImage(
                          placeholder: _loader,
                          errorWidget: _error,
                          imageUrl:item['playlist']['coverImgUrl'],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left:3.0,
                          bottom:3.0,
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.play_arrow,color:Colors.white,size:10.0,),
                              Text(tranNumber(item['playlist']['playCount']),style:TextStyle(color:Colors.white,fontSize:10.0))
                            ],
                          ),
                        )
                      ],
                    )
                ),
                Text(item['playlist']['name'],
                    maxLines:1,
                    overflow: TextOverflow.ellipsis,
                    style:TextStyle(fontSize:13.0,height:1.5))
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
        Text('歌单',textAlign:TextAlign.left,style:TextStyle(fontSize:16.0, fontWeight:FontWeight.bold)),
        GridView.count(
            primary: false,
            padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
            crossAxisCount: 2,
            shrinkWrap: true,
            children: songRanks.map((item){
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: <Widget>[
                          new CachedNetworkImage(
                            placeholder: _loader,
                            errorWidget: _error,
                            imageUrl:item['playlist']['coverImgUrl'],
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top:3.0,
                            right:3.0,
                            child:Row(
                              children: <Widget>[
                                Icon(Icons.play_circle_outline,color:Colors.white,size:15.0,),
                                Text(tranNumber(item['playlist']['playCount']),style:TextStyle(color:Colors.white,fontSize:16.0))
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  Text(item['playlist']['description'],
                      maxLines:2,
                      overflow: TextOverflow.ellipsis,
                      style:TextStyle(fontSize:14.0,height:1.3))
                ],
              );
            }).toList()
        ),

      ],
    );

    return  Material(

      child:RefreshIndicator(
        color:Colors.deepPurple,
        key: _refreshIndicatorKey,
        onRefresh: _getData, // onRefresh 参数是一个 Future<Null> 的回调
        child:  ListView(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
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


          ],
        ),
      )


    );

  }
}