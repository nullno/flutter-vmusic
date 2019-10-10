/*
*搜索页
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
  List<dynamic> songLists = [];
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败

  @override
  void initState() {
    super.initState();

    print(widget.params);
    _flashData();

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
                        child:Container(
                          alignment:Alignment.center,
                          height:30.0,
                          padding: EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            border: new Border.all(width: 1.0, color: Colors.grey),
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                          ),
                          child:TextField(
                              cursorWidth:1.0,
                              cursorColor:Colors.black,

                              decoration: InputDecoration(
                                fillColor:Colors.redAccent,
                                border: OutlineInputBorder(

                                  borderSide: BorderSide(
                                    color: Colors.redAccent,
                                    width:2.0
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
    Widget mainWarp= ListView(
      children: <Widget>[
        songs
      ],
    );


    //主内容区
    return  Material(
      color:Colors.white,
      child: new Stack(
          children: <Widget>[
            Scaffold(
                appBar:appNav ,
                body:mainWarp
            ),

          ],
        ),

    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}
