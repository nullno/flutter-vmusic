import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';

import 'package:flutter_vmusic/utils/tool.dart';
import 'package:flutter_vmusic/utils/FixedSizeText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter_vmusic/conf/api.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';



class SongMenuList extends StatefulWidget{
  final Map params;
  SongMenuList({
    Key key,
    this.params,
  }) : super(key: key);
  @override
  _SongMenuList createState() => _SongMenuList();
}

class _SongMenuList extends State<SongMenuList> with SingleTickerProviderStateMixin{


  //歌单详情
  Map songDetail =  new Map();
  //加载状态
  int loadState   = 0; //0加载中 1加载成功 2加载失败
  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeySong = new GlobalKey<RefreshIndicatorState>();


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
        backgroundColor:Colors.black,
        elevation: 0,
        brightness: Brightness.dark,
        bottom:PreferredSize(
            child:Container(
              color:Colors.black,
              width: double.infinity,

              height:40.0,
              child:Material(
                color:Colors.transparent,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:IconButton(
                        onPressed: (){
                                Navigator.pop(context);
                        },
                        icon:Icon(Icons.arrow_back,color: Colors.white,size:25.0),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child:Container(
                        alignment:Alignment.centerLeft,
                        child: FixedSizeText( songDetail.isEmpty?"loading...":songDetail['name'],maxLines:1,overflow:TextOverflow.ellipsis, style:TextStyle(color:Colors.white),),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child:IconButton(
                          onPressed: (){},
                          color:Colors.redAccent,
                          icon:Icon(Icons.search,color: Colors.white,size:25.0),
                        )
                    )
                  ],
                ),
              ),


        )
    ),
      )
    );


    //头部信息
    Widget headInfo= Container(
            height:250.0,
            color:Colors.black,
            child:Stack(
              children: [
                new CachedNetworkImage(
                  placeholder: _loaderImg,
                  imageUrl: songDetail.isEmpty?"":songDetail['coverImgUrl'],//item['picUrl'],
                  fit: BoxFit.cover,
                  width:double.infinity,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: new Container(
                    color:Colors.white.withOpacity(0.0),
                   width: 500,
                  ),
                ),
                Container(
                  child: Text('sdvsdv'),
                )
              ],
            ),


    );


    //歌曲列表
    Widget songs=Container(
      color:Colors.transparent,
      child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                padding: EdgeInsets.all(15.0),
                color:Colors.white,
                height:1000.0,
                child:Column(
                  children: <Widget>[
                    Text("5555")
                  ],
                )
            ),
          ),
    );


    //主内容区
    Widget mainWarp= ListView(
      children: <Widget>[
        headInfo,
        songs
      ],
    );


    //主内容区
    return  Material(
      color:Colors.white,
      child: RefreshIndicator(
        key: _refreshIndicatorKeySong,
        onRefresh: _flashData,
        child: new Stack(
          children: <Widget>[
            Scaffold(
                appBar:appNav ,
                body:mainWarp
            ),

           ],
        ),

      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}
