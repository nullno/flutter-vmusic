import 'package:flutter/material.dart';

import 'package:flutter_vmusic/utils/tool.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter_vmusic/conf/api.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';



class SongMenu extends StatefulWidget{
  final Map params;
  SongMenu({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _SongMenu createState() => _SongMenu();
}

class _SongMenu extends State<SongMenu> with SingleTickerProviderStateMixin{


  //歌单
  List<dynamic> songLists = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败
  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeySong = new GlobalKey<RefreshIndicatorState>();

  Map  loadMore={
    "Text":"正在加载中",
    "Page":0,
    "hasMore":true,
    "isScrollBottom":true,
  };

  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    addloadMore();
    _flashData();
  }

  //  全部mv监听加载更多
  addloadMore(){
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent.toStringAsFixed(0);
      var pixel = _scrollController.position.pixels.toStringAsFixed(0);
      
      print(maxScroll == pixel);
      print(loadMore["hasMore"]);
      if (maxScroll == pixel && loadMore["hasMore"]) {

        setState(() {
          loadMore["Text"] = "正在加载中...";
          loadMore["isScrollBottom"]=true;
          getHighqualitySongList({"cat":'全部',"before":loadMore['page']},(res){
                      loadMore['hasMore']=res['more'];
                      loadMore['page']=res['lasttime'];
                      res['playlists'].forEach((aitem)=>{
                        songLists.add(aitem)
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

    // 获取推荐歌单
    await  getHighqualitySongList({"cat":'全部',"before":0},(res){
      status = 1;
      loadMore['hasMore']=res['more'];
      loadMore['page']=res['lasttime'];
      loadMore["isScrollBottom"]=false;
      songLists=res['playlists'];

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
        child:Icon(Icons.headset,size:75.0,color:Colors.grey,),
      );
    }

    //主内容区
    return  Material(
        color:Colors.white,
        child: RefreshIndicator(
            key: _refreshIndicatorKeySong,
            onRefresh: _flashData,
            child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  const SliverAppBar(
                    floating: false, pinned: true, snap: false,
                    expandedHeight: 200.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: FixedSizeText('歌单广场',style:TextStyle(fontSize:14.0)),
                    ),

                  ),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(15.0,0.0,15.0,0.0),
                      sliver:SliverGrid(
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //Grid按两列显示
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildListDelegate(
                          songLists.map((item){
                            return  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Stack(
                                      children: <Widget>[
                                        new CachedNetworkImage(
                                          placeholder: _loaderImg,
                                          imageUrl:item['coverImgUrl'],//item['picUrl'],
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
                                ),
                                Container(
                                  padding:EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                                  child:FixedSizeText(item['name'],
                                      maxLines:2,
                                      overflow: TextOverflow.ellipsis,
                                      style:TextStyle(fontSize:14.0)),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      )
                  ),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,50.0),
                      sliver:SliverToBoxAdapter(
                          child: Visibility(child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width:15.0,
                                height:15.0,
                                margin:EdgeInsets.all(5.0),
                                child:Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
                              ),
                              FixedSizeText(loadMore["Text"],textAlign:TextAlign.center,style:TextStyle(height:1))
                            ],
                          ),
                            visible:loadMore["isScrollBottom"],
                          )
                      ),
                  ),


                ]
            ),
          ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}




