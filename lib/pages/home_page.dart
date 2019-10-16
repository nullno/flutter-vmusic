import 'package:flutter/material.dart';
//import 'dart:ui';
import 'package:flutter_vmusic/components/playPanel.dart';
import 'package:flutter_vmusic/components/exitApp.dart';
//三大模块
import 'package:flutter_vmusic/components/find.dart';
//import 'package:flutter_vmusic/components/my.dart';
import 'package:flutter_vmusic/components/video.dart';

import 'package:flutter_vmusic/conf/platform.dart';
import 'package:flutter_vmusic/conf/router.dart';


class HomePage extends StatefulWidget{
 final Map params;
     HomePage({
        Key key,
        this.params,
      }) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin{

 //主页退出app确认
  Future<bool> _onWillPop()=>exitApp(context);
  //自定义打开Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //滑动切配置（自定义TabBar和TabBarView联动）
  TabController controller;//tab控制器
  int _currentIndex = 0; //选中下标



  List<Map> tabList = [{'title':'发现'},{'title':'视频'}];//tab集合

  @override
  void initState() {
    super.initState();

    SYS.systemUI(Colors.transparent,Colors.black,Brightness.light);

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

  @override
  Widget build(BuildContext context) {
   //播放面板
    final mPlayPanel = PlayPanel();

    //侧栏
    Widget mDrawer = new Drawer(//New added
      child: new Text('还不知道放什么'),//New added
    );

    Widget getModule(int i) {
      Widget mainBlock;
      switch(i){
//          case 0:
//            mainBlock = MyCenter();
//          break;
          case 0:
            mainBlock = Find();
            break;
          case 1:
            mainBlock = VideoList();
          break;
       }

       return mainBlock;

    }

    //顶部导航
     Widget appNav = PreferredSize(
       preferredSize: Size.fromHeight(40.0),
       child:AppBar(
         backgroundColor:Colors.white,
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
                           _scaffoldKey.currentState.openDrawer();
                         },
                         icon:Icon(Icons.menu,color: Colors.black,size:25.0),
                       ),
                     ),
                     Expanded(
                       flex: 5,
                       child:Container(
                         alignment:Alignment.center,
                         child: new TabBar(
                           controller: controller,//控制器
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
                       ),
                     ),
                     Expanded(
                         flex: 1,
                         child:IconButton(
                           onPressed: (){
                             Router.fadeNavigator(context,"/searchpage",{'seachParam':{},'from':'/find'},(res){});

                           },
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

    //滑动容区
     Widget slideView = TabBarView(
      controller: controller,
      children: tabList.asMap().keys.map((index) {
        return getModule(index);
      }).toList(),
     );

   //主内容区
     Widget homeWarp = new Stack(
      children: <Widget>[
        DefaultTabController(
           length:tabList.length,
           child:Scaffold(
             appBar: appNav,
             body:slideView
           )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child:mPlayPanel
        ),
      ],
    );

    return WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
            key: _scaffoldKey,
            drawer:mDrawer,//New added
            body:homeWarp
        )
      );

  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;

}




