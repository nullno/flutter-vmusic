/*
*搜索页
 */

import 'package:flutter/material.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:ui';

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
  List<dynamic> songLists = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败

  //搜索状态
  int searchState = 0; //0未搜索 1搜索完成


  //关键字
  Map seachParam = {
    "keywords":'',
    "offset":0,
    "type":1018
  };

  //初始化滚动监听器，加载更多使用
  ScrollController _scrollController = new ScrollController();
  //搜索框控制控制器
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        suggestLists.clear();
      });
    });
    _flashData();

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


  @override
  Widget build(BuildContext context) {

    Widget _loaderImg(BuildContext context, String url) {
      return new Center(
        widthFactor:12.0,
        child:Loading(indicator: LineScalePulseOutIndicator(), size: 50.0),
      );
    }

    //顶部导航
    Widget appNav =PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child:AppBar(
          backgroundColor:Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          bottom:PreferredSize(
              child:Container(
                color:Colors.white,
                width: double.infinity,
                height:40.0,
                child:Material(
                  color:Colors.transparent,
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child:IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon:Icon(Icons.arrow_back,color: Colors.black,size:25.0),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                              alignment:Alignment.center,
                              height:30.0,
                              padding: EdgeInsets.all(0.0),
                              decoration: new BoxDecoration(
                                border: new Border.all(width: 1.0, color: Colors.grey),
                                color: Colors.transparent,
                                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                              ),
                              child:TextField(
                                controller: _searchController,
                                cursorWidth:1.5,
                                cursorColor:Colors.black,
                                cursorRadius:Radius.circular(1.0),
                                textInputAction:TextInputAction.search,
                                onChanged: (val) {
                                  setState(() {
                                    seachParam['keywords']=val;
                                  });
                                  if(val!=''){
                                    //搜索建议
                                    searchSuggest({"keywords":val},(res){
                                      setState(() {
                                       if(!res['result'].isEmpty) {
                                          suggestLists=res['result']['allMatch'];
                                      }else{
                                             suggestLists.clear();
                                         }
                                      });
                                    },(err){
                                      print(err);
                                    });
                                  }else{
                                    setState(() {
                                      suggestLists.clear();
                                      seachParam['keywords']='';
                                    });
                                  }
                                },
                                onSubmitted: (val) {//内容提交(按回车)的回调

                                },

                                textAlignVertical:TextAlignVertical.center,
                                decoration: InputDecoration(
                                  contentPadding:EdgeInsets.fromLTRB(10.0,15.0,0,0.0),
                                  hintText:'请输入关键词...',
                                  suffixIcon:Visibility(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Material(
                                          color:Colors.white,
                                          child:InkWell(
                                              onTap: (){
                                                //清除搜索框
                                                _searchController.clear();
                                                setState(() {
                                                  suggestLists.clear();
                                                  seachParam['keywords']='';
                                                });
                                              },
                                              child:Icon(Icons.clear,color:Colors.grey,size:15.0)) ,
                                        )
                                    ),
                                   visible: seachParam['keywords']!=''
                                  ),
                                  enabledBorder:OutlineInputBorder(
                                    gapPadding:0.0,
                                    borderRadius:BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color:Colors.transparent,
                                        style:BorderStyle.none
                                    ),),
                                  border: OutlineInputBorder(
                                    gapPadding:0.0,
                                    borderRadius:BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color:Colors.transparent,
                                        style:BorderStyle.none
                                    ),
                                  ),
                                ),
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
                            icon:Icon(Icons.search,color: Colors.black,size:25.0),

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
    Widget HotRank = Container(
      padding: EdgeInsets.all(15.0),
      color:Colors.white,
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height:30,
            width:75,
            child: FlatButton.icon(padding: EdgeInsets.all(0), icon: Icon(Icons.whatshot,color:Colors.red), label: FixedSizeText("热搜榜",textAlign:TextAlign.left,style:TextStyle(height:1,fontSize:15.0,fontWeight:FontWeight.bold))),
          ),
          Column(
            children: hotRankLists.asMap().keys.map((index){
              return  Material(
                color:Colors.transparent,
                child: InkWell(
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child:  Container(
                    margin:EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
                    padding:EdgeInsets.fromLTRB(10.0,0.0,15.0,0.0) ,
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: FixedSizeText((index+1).toString(),textAlign:TextAlign.left,style:TextStyle(color:index<3?Colors.red:Colors.grey,fontSize:14.0)),
                        ),
                        Expanded(
                          flex: 10,
                          child:Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                crossAxisAlignment:CrossAxisAlignment.center,
                                mainAxisAlignment:MainAxisAlignment.start,
                                children: <Widget>[
                                  FixedSizeText(hotRankLists[index]['searchWord'],maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.black,fontSize:13.0)),
                                  Padding(
                                    padding:EdgeInsets.all(5.0),
                                    child: FixedSizeText(hotRankLists[index]['score'].toString(),maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Color(0xFFCEC9C9),fontSize:9.0,fontStyle:FontStyle.italic)),
                                  ),
                                  SizedBox(
                                    height:15.0,
                                    child:hotRankLists[index]['iconUrl']!=null?Image.network(hotRankLists[index]['iconUrl']):Container(),
                                  ),
                                ]) ,
                                FixedSizeText(hotRankLists[index]['content'],maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.grey,fontSize:10.0)),
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
    );

   //搜索建议
    Widget Suggest = Positioned(
      top:40.0,
      child:Container(
        width:250,
        padding:EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            color:Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(2.0)),//设置圆
            boxShadow: <BoxShadow>[new BoxShadow(color: Colors.grey, blurRadius: 5.0)]
        ),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:  suggestLists.map((item){
            return  Material(
              color:Colors.transparent,
              child: InkWell(
                onTap: (){
                  _searchController.value=TextEditingValue(text:item['keyword']);
                   FocusScope.of(context).requestFocus(FocusNode());
                   setState(() {
                     suggestLists.clear();
                   });

                },
                child:Container(
                  width:double.infinity,
                  padding:EdgeInsets.only(top:10.0,bottom:10.0),
                  child:  Text(item['keyword']),
                ),
              ) ,
            );
          }).toList()

        ),
      ) ,
    );
    //歌曲列表
    Widget songs=Container(
      color:Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            padding: EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
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
                          child:
                          Row(
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
    Widget mainWarp= ListView(
      controller: _scrollController,
      children: <Widget>[
        hotRankLists.length>0&&searchState==0?HotRank:Container(),
      ],
    );



    //主内容区
    return  Material(
      color:Colors.white,
      child:SafeArea(
        child: GestureDetector(
//        behavior: HitTestBehavior.translucent,
         onTap: () {
           // 触摸收起键盘
             print('vdv');
             FocusScope.of(context).requestFocus(FocusNode());
            },
          child: new Stack(
          alignment:Alignment.bottomCenter,
          children: <Widget>[
            Scaffold(
                appBar:appNav ,
                body:mainWarp
            ),
            suggestLists.length>0?Suggest:Container(),
          ],
          ) ,
        )

      )
    );
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
  }

}
