import 'package:flutter/material.dart';
import 'package:flutter_vmusic/conf/router.dart';
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


  //滑动切配置（自定义TabBar和TabBarView联动）
  TabController controller;//tab控制器
  int _currentIndex = 0; //选中下标

  List<Map> tabList = [{'title':'全部'},{'title':'华语'},{'title':'古风'},{'title':'欧美'},{'title':'流行'}];//tab集合
  //歌单
  List<dynamic> songLists = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败
  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeySong = new GlobalKey<RefreshIndicatorState>();

  Map  loadMore={
    "Text":"正在加载中",
    "Page":0,
    "type":"全部",
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
    //初始化controller并添加监听
    controller = TabController(initialIndex:0,length: tabList.length, vsync: this);
    controller.addListener((){
      if (controller.index.toDouble() == controller.animation.value) {
        //赋值 并更新数据
        this.setState(() {
          _currentIndex = controller.index;
        });
      }
    });
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
          getHighqualitySongList({"cat":loadMore['type'],"before":loadMore['page']},(res){
                      loadMore['hasMore']=res['more'];
                      loadMore['page']=res['lasttime'];
                      loadMore["isScrollBottom"]=false;
                      res['playlists'].forEach((aitem)=>{
                        songLists.add(aitem)
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
    await  getHighqualitySongList({"cat":loadMore['type'],"before":0},(res){
      status = 1;
      loadMore['hasMore']=res['more'];
      loadMore['page']=res['lasttime'];
      loadMore["isScrollBottom"]=false;
      songLists.clear();
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
        child:Loading(indicator: LineScalePulseOutIndicator(), size: 50.0),
      );
    }
    Widget _loaderImgBlank(BuildContext context, String url) {
      return new Center(
        child:Icon(Icons.image,size:158,color: Colors.grey,)
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
                  SliverAppBar(
                    floating: true, pinned: false, snap: true,
                    expandedHeight: 200.0,
                    backgroundColor:Colors.black,
                    brightness: Brightness.dark,
                    title: FixedSizeText('歌单广场',style:TextStyle(fontSize:16.0,color:Colors.white)) ,
                    iconTheme: IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                        background: new CachedNetworkImage(
                          placeholder: _loaderImg,
                          imageUrl:songLists.length>0?songLists[0]['coverImgUrl']:"",//item['picUrl'],
                          fit: BoxFit.cover,
                        ),
                       ),
                      bottom:PreferredSize(
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                ],
                              ),
                            ),
                          child: TabBar(
                         controller: controller,
                         labelColor: Colors.red,
                         unselectedLabelColor: Colors.white,
                         indicatorColor: Colors.redAccent, //
                         tabs:tabList.map((item) {
                           return  new Tab(text: item['title']);
                         }).toList(),
                         //点击事件
                         onTap: (int i) {
                           setState(() {
                             loadMore['type'] = tabList[i]['title'];
                             _flashData();
                           });
                         },
                       ),),
                    ),

                   ),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(15.0,15.0,15.0,0.0),
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
                                InkWell(
                                onTap: (){
                                    Router.fadeNavigator(context,"/songmenulist",{'id':item['id'],'from':'/songmenu'},(res){});
                                  },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Stack(
                                      children: <Widget>[
                                        new CachedNetworkImage(
                                          placeholder: _loaderImgBlank,
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
                              loadMore["hasMore"]?Container(
                                width:15.0,
                                height:15.0,
                                margin:EdgeInsets.all(5.0),
                                child:Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
                              ):Container(),
                              FixedSizeText(loadMore["Text"],textAlign:TextAlign.center,style:TextStyle(height:1,fontSize:12.0))
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





/*
 Sliver头
 SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          TabBar(
                        controller: controller,
                        labelColor: Colors.red,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black, //
                        tabs:tabList.map((item) {
                          return  new Tab(text: item['title']);
                        }).toList(),
                        //点击事件
                        onTap: (int i) {
                            setState(() {
                                loadMore['type'] = tabList[i]['title'];
                                _flashData();
                              });
                          print(i);
                        },
                      )
                      )
                  ),

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
      color:Colors.white,
      padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
 */