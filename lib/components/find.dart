/*
推荐模块
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

class Find extends StatefulWidget{

  @override

  State createState() => new _Find();

}

class _Find extends State<Find> with SingleTickerProviderStateMixin{

  TabController controller;//tab控制器
  int _currentIndex = 0; //选中下标

  List<Map> adList = [{'title':'标题1','imgpath':'http://p1.music.126.net/h_G8a9xxeXTmwjcB8mR0pQ==/109951164372410150.jpg','link':''},
                       {'title':'标题1','imgpath':'http://p1.music.126.net/ifxuv3opkDlaljb2BDfT0Q==/109951164372452784.jpg','link':''},
                       {'title':'标题1','imgpath':'http://p1.music.126.net/5l0td3TZQg4pyX8oNdeaqA==/109951164372575001.jpg','link':''},];//tab集合

  //下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    //初始化controller并添加监听
    controller = TabController(initialIndex:0,length: adList.length, vsync: this);
    controller.addListener((){
      if (controller.index.toDouble() == controller.animation.value) {
        //赋值 并更新数据
        this.setState(() {
          _currentIndex = controller.index;
        });
      }
    });
  }

  Future<Null> _getData() {
    final Completer<Null> completer = new Completer<Null>();

    // 启动一下 [Timer] 在3秒后，在list里面添加一条数据，关完成这个刷新
    new Timer(Duration(seconds: 2), () {
      // 添加数据，更新界面
      setState(() {

      });

      // 完成刷新
      completer.complete(null);
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {

    Widget _loader(BuildContext context, String url) {
      return new Center(
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

    //slide banner图
    Widget slideBanner = TabBarView(
      controller: controller,
      children:  adList.map((item){
        return Container(
            margin:EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:Container(
              color:Colors.deepPurple,
              child: new CachedNetworkImage(
                placeholder: _loader,
                errorWidget: _error,
                imageUrl: item['imgpath'],
                fit: BoxFit.fitWidth,
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
          crossAxisCount: 3,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child:  new CachedNetworkImage(
              placeholder: _loader,
              errorWidget: _error,
              imageUrl:'https://p4.music.126.net/N2HO5xfYEqyQ8q6oxCw8IQ==/18713687906568048.jpg',
              fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.teal[100],
              child: new CachedNetworkImage(
                placeholder: _loader,
                errorWidget: _error,
                imageUrl:'https://p3.music.126.net/34YW1QtKxJ_3YnX9ZzKhzw==/2946691234868155.jpg',
                fit: BoxFit.cover,
                ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('He\'d have you all unravel at the'),
              color: Colors.teal[100],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Heed not the rabble'),
              color: Colors.teal[200],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ), Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ), Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ),
          ],
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
              height: 166.0,
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0, 10.0),
              color: Colors.white,
              child: slideBanner,
            ),
            Container(
              margin:EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: songRank,
            ),


          ],
        ),
      )


    );

  }
}