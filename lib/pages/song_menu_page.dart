import 'package:flutter/material.dart';

import 'package:flutter_vmusic/utils/tool.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter_vmusic/conf/api.dart';
//三大模块




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

  @override
  void initState() {
    super.initState();
    getData((status){
      setState(() {
        loadState=status;
      });
    });
  }


  //获取数据
  void getData(complete) async{
    var status = 0;

    // 获取推荐歌单
    await  getPersonalizedSongList((res){
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

    Widget _loaderImg(BuildContext context, String url) {
      return new Center(
        widthFactor:12.0,
        child:Icon(Icons.headset,size:75.0,color:Colors.grey,),
      );
    }
    //顶部导航
    Widget appNav = PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child:AppBar(
          backgroundColor:Colors.white12,
          elevation: 0,
          brightness: Brightness.light,
          bottom:PreferredSize(
            child:Container(
              width: double.infinity,
              height:40.0,
              child:Material(
                color:Colors.white,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:IconButton(
                        onPressed: (){
                          Navigator.pop(context,'我是来自SecondPage的数据');
                        },
                        icon:Icon(Icons.arrow_back,color: Colors.black,size:25.0),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child:Container(
                        alignment:Alignment.center,
                        child:Text('歌单'),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child:IconButton(
                          onPressed: (){},
                          color:Colors.redAccent,
                          icon:Icon(Icons.search,color: Colors.black,size:25.0),
                        )
                    )
                  ],
                ),
              ),

            ), preferredSize: null ,
          ) ,
        )
    );



    //主内容区
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Demo'),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.82,
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
                           imageUrl:item['picUrl'],//item['picUrl'],
                           fit: BoxFit.cover,
                         ),
                         Positioned(
                           top:3.0,
                           right:3.0,
                           child:Row(
                             children: <Widget>[
                               Icon(Icons.play_circle_outline,color:Colors.white,size:15.0,),
                               Text(tranNumber(item['playCount']),style:TextStyle(color:Colors.white,fontSize:16.0))
                             ],
                           ),
                         )
                       ],
                     )
                 ),
                 Container(
                   padding:EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                   child:Text(item['name'],
                       maxLines:2,
                       overflow: TextOverflow.ellipsis,
                       style:TextStyle(fontSize:14.0,height:1.2)),
                 )

               ],
             );
             }).toList(),
           ),
        ),


      ],
    );

  }

  @override
  void dispose() {
    super.dispose();
  }

}




