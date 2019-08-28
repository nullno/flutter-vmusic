import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LandingPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
     return Material(
           child: Stack(
             alignment: FractionalOffset(0.5, 0.9),
             children: <Widget>[
               Positioned(
                 child: Container(
                     color:Colors.black,
                     width: double.infinity,
                     height: double.infinity,
                     child:Image.network('https://hbimg.huabanimg.com/ae0c42acc468194648df5bba2234358615b7fe641d467-x3IjRC_fw658',fit: BoxFit.cover)
                 ) ,
               ),
               Positioned(
                 child: Container(
                     color:Colors.black45,
                     width: double.infinity,
                     height: double.infinity,
                 ) ,
               ),

               Positioned(
                 top:250,
                 child: Column(
                   children: <Widget>[
                     Text('VMUSIC',style:TextStyle(color:Colors.white,fontSize:50.0,fontWeight:FontWeight.w500),),
                     Container(
                       width:300,
                       height:3,
                       margin:EdgeInsets.all(20.0),
                       decoration: new BoxDecoration(
                           border: Border.all(color: Colors.white, width: 2),
                           borderRadius: BorderRadius.circular(10.0)
                       ),

                      ),
                     Text('全网音乐随身听',style:TextStyle(color:Colors.white,fontSize:20.0),)
                   ],
                 ),
               ),

               Positioned(
                 child:RaisedButton(
                     onPressed: () {
                       print("点击了");
                     },
                     color:Color(0xff00CD81),
                     splashColor:Color(0xff221535),
                     elevation: 0.0,
                     highlightElevation: 0.0,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(22.0))),
                     padding:EdgeInsets.fromLTRB(50,10,50,10),
                     child:Text('开始进入',style:TextStyle(color:Colors.white, fontSize:16),textAlign: TextAlign.center)
                 ),
               ),

             ],
           )

     );
  }
}