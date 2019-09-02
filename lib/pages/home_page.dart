import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_vmusic/components/playPanel.dart';
import 'package:flutter_vmusic/components/exitApp.dart';

class HomePage extends StatefulWidget{
 final Map params;
     HomePage({
        Key key,
        this.params,
      }) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  Future<bool> _onWillPop()=>exitApp(context);

  @override
  Widget build(BuildContext context) {


    var homeUi=new Column(
       children: <Widget>[
         //导航栏
         Container(
           width: double.infinity,
           height:40.0,
           padding:EdgeInsets.fromLTRB(0,5.0,0,5.0),
           child:Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
           Expanded(
             flex: 1,
           child:RawMaterialButton(
                 onPressed: (){},
                 padding: EdgeInsets.all(0.0),
                 child:Icon(Icons.menu,color: Colors.black,size:25.0),
               ),
           ),
          Expanded(
            flex: 5,
           child:Container(
                 alignment:Alignment.center,
                 child: ListView(
                   scrollDirection: Axis.horizontal,
                   shrinkWrap: true,
                   reverse: false,
//                   padding: EdgeInsets.fromLTRB(0,15.0,0,0),
                   children: <Widget>[
                     RawMaterialButton(
                       onPressed: (){},
                       child:  Text('我的',style:TextStyle(fontWeight:FontWeight.normal,fontSize:15.0),),
                     ),
                     RawMaterialButton(
                       onPressed: (){},
                       child:  Text('发现',style:TextStyle(fontWeight:FontWeight.bold,fontSize:16.0),),
                     ),
                     RawMaterialButton(
                       onPressed: (){},
                       child:  Text('视频',style:TextStyle(fontWeight:FontWeight.normal,fontSize:15.0),),
                     ),

                   ],
                 ) ,
               ),
        ),
           Expanded(
             flex: 1,
              child:RawMaterialButton(
                 onPressed: (){},
                 child:Icon(Icons.search,color: Colors.black,size:25.0),
               )
             )
             ],
           ),
         ),
         //主界面
         Center(child:Text('VMUSIC'))
       ],
    );
    //当前播放歌曲

    var warp=new Stack(
      children: <Widget>[
        homeUi,
        Align(
          alignment: Alignment.bottomCenter,
          child:PlayPanel()
        ),
      ],
    );


    return WillPopScope(
        onWillPop: _onWillPop,
        child:Material(
            child: Container(
              margin:EdgeInsets.fromLTRB(0,MediaQueryData.fromWindow(window).padding.top,0,0),
              color:Colors.white,
              child: warp,
            ),
      )
    );
  }
}