/*
*搜索页
 */

import 'package:flutter/gestures.dart';
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



class SearchPage extends StatefulWidget{
  final Map params;
  SearchPage({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> with SingleTickerProviderStateMixin{


  //歌单详情
  Map songDetail =  new Map();
  List<dynamic> hotRankLists = [];
  List<dynamic> suggestLists = [];

  List<dynamic> resultSongs = [];
  List<dynamic> resultMvs = [];
  List<dynamic> resultVideos = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败

  //搜索状态
  int searchState = 0; //搜索当前页 0未搜索 1搜索显示
  int searchLoadSong = 0; //请求状态 0搜索中 1搜完成
  int searchLoadVideo = 0; //请求状态 0搜索中 1搜完成

  List<Map> tabList = [{'title':'单曲','type':1},{'title':'视频','type':1014}];//tab集合

  //关键字
  Map seachParam = {
    "keywords":'',
    "offset":0,
    "type":1
  };

  Map  loadMore={
    "Text":"正在加载中",
    "Page":0,
    "hasMore":true,
    "isScrollBottom":false,
  };

  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerSong = new ScrollController();
  ScrollController _scrollControllerVideo = new ScrollController();
  //搜索框控制控制器
  TextEditingController _searchController = TextEditingController();
  //滑动切配置（自定义TabBar和TabBarView联动）
  TabController _tabController;//tab控制器
  int _tabCurrentIndex = 0; //选中下标

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        suggestLists.clear();
      });
    });
    //单曲
    _scrollControllerSong.addListener(() {
      scrollLoadmore(_scrollControllerSong);
    });
    //视频
    _scrollControllerVideo.addListener(() {
      scrollLoadmore(_scrollControllerVideo);
    });
    if(!widget.params['seachParam'].isEmpty){
      //初始化controller并添加监听
      _tabController = TabController(initialIndex:0,length: tabList.length, vsync: this);
      _tabController.addListener((){
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          //赋值 并更新数据
          this.setState(() {
            _tabCurrentIndex = _tabController.index;

            doSearch(isTab:true);

          });

        }
      });

        setState(() {
          seachParam=widget.params['seachParam'];
          searchState=1;
          _searchController.value=TextEditingValue(text:seachParam['keywords']);
          doSearch();
        });
    }else{
      _flashData();
    }

  }

   scrollLoadmore(SC){
     FocusScope.of(context).requestFocus(FocusNode());
     setState(() {
       suggestLists.clear();
     });
     var maxScroll = SC.position.maxScrollExtent.toStringAsFixed(0);
     var pixel = SC.position.pixels.toStringAsFixed(0);

     if (maxScroll == pixel && loadMore["hasMore"]&&!loadMore["isScrollBottom"]) {
       setState(() {
         loadMore["Text"] = "正在加载中...";
         loadMore["isScrollBottom"] = true;
         doSearch(isMore:true,newSearch:false);
       });

     }else if(!loadMore['hasMore']) {
       setState(() {
         loadMore["isScrollBottom"]=true;
         loadMore["Text"] = "~全部结果已加载完成~";
       });
     }

   }

  //  刷新获取数据
    _flashData(){
    getData((status){
      setState(() {
        loadState=status;

      });
    });
  }

  //获取数据
  void getData(complete) async{
    var status = 0;
    //热搜榜详细列表
    await  searchHot((res){
      hotRankLists=res['data'];
    },(err){
      status = 2;
      print(err);
    });
    complete(status);
  }

  //搜索
  void doSearch({bool isTab:false,bool isMore:false,bool newSearch:true}){

    if(seachParam['keywords']==''){
      return;
    }
    if(searchState==0){
      Router.fadeNavigator(context,"/searchpage",{'seachParam':seachParam,'from':'/search'},(success){
        setState(() {
          seachParam['keywords']='';
          searchState = 0;
          _searchController.clear();
          resultSongs.clear();
          resultVideos.clear();
          seachParam['offset']=0;
          loadMore['Page']=0;
          loadMore["isScrollBottom"]=false;
          loadMore["hasMore"]=true;
        });
      });
    }else{
      //新搜索清除
      if(isTab || newSearch){
        setState(() {
          resultSongs.clear();
          resultVideos.clear();
          seachParam['offset'] = 0;
          loadMore['Page'] = 0;
          loadMore["isScrollBottom"] = false;
          loadMore["hasMore"] = true;
        });
      }
      seachParam['type']=tabList[_tabCurrentIndex]['type'];

      setState(() {
        searchLoadSong=0;
        searchLoadVideo=0;
       });

      print(seachParam);
      search(seachParam,(res){


          setState(() {
            switch(seachParam['type']) {
              case 1:
                searchLoadSong = 1;

                if (res['result']['songCount'] > 0) {
                  print(res['result']['songCount']);


                  res['result']['songs'].forEach((aitem)=>{
                    resultSongs.add(aitem)
                  });

                  if(resultSongs.length>=res['result']['songCount']){
                    loadMore["hasMore"]=false;
                  }
                  loadMore['Page']=loadMore['Page']+1;
                  loadMore["isScrollBottom"]=false;
                  seachParam['offset']=loadMore['Page']*10;

                }
                break;
              case 1014:
                searchLoadVideo = 1;
                if (!res['result'].isEmpty) {

                  print(res['result']['videoCount']);

                  res['result']['videos'].forEach((aitem)=>{
                    resultVideos.add(aitem)
                  });

                  if(resultVideos.length>=res['result']['videoCount']){
                    loadMore["hasMore"]=false;
                  }
                  loadMore['Page']=loadMore['Page']+1;
                  loadMore["isScrollBottom"]=false;
                  seachParam['offset']=loadMore['Page']*10;

                }
                break;
            }
          });


      },(err){

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
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            height: 30.0,
                            padding: EdgeInsets.all(0.0),
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                  width: 1.0, color: Colors.grey),
                              color: Colors.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0)),
                            ),
                            child: TextField(
                              controller: _searchController,
                              dragStartBehavior: DragStartBehavior.down,
                              cursorWidth: 1.5,
                              autofocus: seachParam['keywords'] == '',
                              cursorColor: Colors.black,
                              cursorRadius: Radius.circular(1.0),
                              textInputAction: TextInputAction.search,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (val) {
                                setState(() {
                                  seachParam['keywords'] = val;
                                });
                                if (val != '') {
                                  //搜索建议
                                  searchSuggest({"keywords": val}, (res) {
                                    setState(() {
                                      if (!res['result'].isEmpty) {
                                        suggestLists =
                                        res['result']['allMatch'];
                                      } else {
                                        suggestLists.clear();
                                      }
                                    });
                                  }, (err) {
                                    print(err);
                                  });
                                } else {
                                  setState(() {
                                    suggestLists.clear();
                                    seachParam['keywords'] = '';
                                  });
                                }
                              },
                              onSubmitted: (val) { //内容提交(按回车)的回调
                                seachParam['keywords'] = val;
                                doSearch();
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                hintText: '请输入关键词...',
                                hintStyle: TextStyle(fontSize: 12.0),
                                suffixIcon: Visibility(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          _searchController.clear();
                                          setState(() {
                                            suggestLists.clear();
                                            seachParam['keywords'] = '';
                                          });
                                        },
                                        child: Icon(
                                            Icons.clear, color: Colors.grey,
                                            size: 15.0)),

                                  ),
                                  visible: seachParam['keywords'] != '',
                                  replacement: Icon(
                                      Icons.edit, color: Colors.grey,
                                      size: 15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 0.0,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.transparent,
                                      style: BorderStyle.none
                                  ),),
                                border: OutlineInputBorder(
                                  gapPadding: 0.0,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.transparent,
                                      style: BorderStyle.none
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => doSearch(),
                            color: Colors.redAccent,
                            icon: Icon(
                                Icons.search, color: Colors.black, size: 25.0),

                          )
                      )
                    ],
                  ),
                ),


              )
          ),
        )
    );

    //历史纪录

    //热搜榜
    Widget HotRank = ListView(
        controller: _scrollController,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 75,
                  child: FlatButton.icon(padding: EdgeInsets.all(0),
                      icon: Icon(Icons.whatshot, color: Colors.red),
                      label: FixedSizeText("热搜榜", textAlign: TextAlign.left,
                          style: TextStyle(height: 1,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold))),
                ),
                Column(
                  children: hotRankLists
                      .asMap()
                      .keys
                      .map((index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _searchController.value = TextEditingValue(
                              text: hotRankLists[index]['searchWord']);
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            seachParam['keywords'] =
                            hotRankLists[index]['searchWord'];
                            doSearch();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0.0),
                          child:
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: FixedSizeText((index + 1).toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: index < 3 ? Colors.red : Colors
                                            .grey, fontSize: 14.0)),
                              ),
                              Expanded(
                                  flex: 10,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              FixedSizeText(
                                                  hotRankLists[index]['searchWord'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0)),
                                              Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: FixedSizeText(
                                                    hotRankLists[index]['score']
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xFFCEC9C9),
                                                        fontSize: 9.0,
                                                        fontStyle: FontStyle
                                                            .italic)),
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                                child: hotRankLists[index]['iconUrl'] !=
                                                    null
                                                    ? Image.network(
                                                    hotRankLists[index]['iconUrl'])
                                                    : Container(),
                                              ),
                                            ]),
                                        FixedSizeText(
                                            hotRankLists[index]['content'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.grey,
                                                fontSize: 10.0)),
                                      ]
                                  )
                              ),
                            ],

                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          )
        ]);

    //搜索建议
    Widget Suggest = Positioned(
      top: 8.0,
      child: Container(
        width: 250,
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(2.0)), //设置圆
            boxShadow: <BoxShadow>[
              new BoxShadow(color: Colors.grey, blurRadius: 5.0)
            ]
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: suggestLists.map((item) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _searchController.value =
                        TextEditingValue(text: item['keyword']);
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      seachParam['keywords'] = item['keyword'];
                      suggestLists.clear();
                      doSearch();
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(item['keyword']),
                  ),
                ),
              );
            }).toList()

        ),
      ),
    );

    //搜索load
    Widget Loadwidget (load){

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       Visibility(
         child:Container(
          width: 15.0,
          height: 15.0,
          margin: EdgeInsets.all(5.0),
          child: Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
       ),
         visible: load==0,
       ),
        FixedSizeText(
            load == 0 ? "搜索中..." : '暂无结果', textAlign: TextAlign.center,
            style: TextStyle(height: 1, fontSize: 12.0))
      ],
    );
  }
    //搜索分类
    Widget Tabsearch =Positioned(
        top:0,
        left: 0,
        child:Container(
          alignment:Alignment.center,
          color:Colors.white,
          width: Adapt.screenW(),
          padding:EdgeInsets.only(left:10.0,right:10.0),
          height:30.0,
          child: new TabBar(
            controller: _tabController,//控制器
            labelColor: Colors.black, //选中的颜色
            labelStyle: TextStyle(fontSize: 15.0,fontWeight:FontWeight.bold), //选中的样式
            unselectedLabelColor: Colors.black, //未选中的颜色
            unselectedLabelStyle: TextStyle(fontSize: 15), //未选中的样式
            indicatorColor: Colors.redAccent, //下划线颜色
            isScrollable: true, //是否可滑动
            //tab标签
            tabs: tabList.map((item) {
              return new Tab(
                text: item['title'],
              );
            }).toList(),
            //点击事件
            onTap: (int i) {
              print(i);
            },
          ),
        )
    );
    //搜索结果页
    Widget SearchResultSongs(List<dynamic> resultSongs) {
      return ListView.builder(
          controller: _scrollControllerSong,
          padding: EdgeInsets.fromLTRB(0.0,30.0,0.0,30.0),
          itemCount: resultSongs.length,
          itemBuilder: (context, i) => Material(
            color:Colors.transparent,
            child: InkWell(
              onTap: (){},
              child:  Container(
                margin:EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
                padding:EdgeInsets.fromLTRB(15.0,0.0,15.0,0.0) ,
                child:
                Row(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: FixedSizeText((i+1).toString(),textAlign:TextAlign.left,style:TextStyle(color:Colors.grey,fontSize:14.0)),
                    ),
                    Expanded(
                      flex: 6, child:keywordsHighlight(seachParam['keywords'],"${resultSongs[i]['name']}\n/<br>/${resultSongs[i]['artists'][0]['name']}-${resultSongs[i]['album']['name']}"),

                    ),
                    Expanded(
                        flex: 1,
                        child:Visibility(
                          child: Align(
                            alignment:Alignment.topRight,
                            child:  InkWell(onTap: (){},child:Icon(Icons.music_video,color:Colors.redAccent,)),
                          ),
                          visible:resultSongs[i]['mvid']>0,
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
          )
      );
    }
    //搜索结果页
    Widget SearchResultVideos(List<dynamic> resultVideos) {
      return ListView.builder(
          controller: _scrollControllerVideo,
          padding: EdgeInsets.fromLTRB(0.0,30.0,0.0,30.0),
          itemCount: resultVideos.length,
          itemBuilder: (context, i) => Material(
            color:Colors.transparent,
            child: InkWell(
              onTap: (){},
              child:  Container(
                margin:EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
                padding:EdgeInsets.fromLTRB(15.0,0.0,15.0,0.0) ,
                child:
                Row(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child:Container(
                        width:200,
                        height:80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                              child: new CachedNetworkImage(
                                imageUrl: resultVideos[i]['coverUrl'],//item['imageUrl'],
                                fit: BoxFit.cover,
                          ),
                        ),
                      ) ,
                    ),
                Expanded(
                  flex:6,
                  child:Container(
                    padding:EdgeInsets.all(5.0),
                    child: keywordsHighlight(seachParam['keywords'],"${resultVideos[i]['title']}\n/<br>/${formatDuration(resultVideos[i]['durationms'])} by${resultVideos[i]['creator'][0]['userName']}"),

                  ),

                ),


                  ],

                ),
              ),
            ),
          )
      );
    }

    //滑动容区
    Widget TabslideView = TabBarView(
      controller: _tabController,
      children: <Widget>[
          resultSongs.isEmpty?Loadwidget(searchLoadSong): SearchResultSongs(resultSongs),
          resultVideos.isEmpty?Loadwidget(searchLoadVideo):SearchResultVideos(resultVideos),
      ],
    );
    //主内容区
    Widget mainWarp=  new Stack(
        alignment:Alignment.bottomCenter,
      children: <Widget>[
        hotRankLists.length>0&&searchState==0?HotRank:searchState==1?TabslideView:Container(),
        Visibility(child: Tabsearch,visible: (searchState==1)),
        Visibility(child: Suggest,visible: suggestLists.length>0),
        Visibility(
        child:Container(
          width:Adapt.screenW() ,
          color:Colors.white70,
          height:20,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  child: Container(
                    width:15.0,
                    height:15.0,
                    margin:EdgeInsets.all(5.0),
                    child:Loading(indicator: LineScalePulseOutIndicator(), size: 100.0),
                  ),
                  visible:loadMore["hasMore"] ,
                ),
                FixedSizeText(loadMore["Text"],textAlign:TextAlign.center,style:TextStyle(height:1,fontSize:12.0))
              ],
            )
            ) ,
          visible:loadMore["isScrollBottom"],

        ),
      ]

    );


    //主内容区
    return  Material(
      color:Colors.white,
      child:SafeArea(
        child: GestureDetector(
//        behavior: HitTestBehavior.translucent,
         onTap: () {
           // 触摸收起键盘
             FocusScope.of(context).requestFocus(FocusNode());
            },
          child: Scaffold(
                backgroundColor:Colors.white,
                appBar:appNav ,
                body:Container(child:mainWarp , )
            ),
          ) ,
        )
    );
  }
  @override
  void dispose() {

//    _scrollController.dispose();
//    _scrollControllerSong.dispose();
//    _scrollControllerVideo.dispose();
//    _searchController.dispose();
//    _tabController.dispose();
    super.dispose();
  }

}
