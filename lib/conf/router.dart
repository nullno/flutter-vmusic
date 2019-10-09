/*
路由信息配置
*/
import 'package:flutter/material.dart';
import 'package:flutter_vmusic/utils/custom.dart';

import 'package:flutter_vmusic/pages/landing_page.dart';
import 'package:flutter_vmusic/pages/home_page.dart';

import 'package:flutter_vmusic/pages/song_menu_page.dart';
import 'package:flutter_vmusic/pages/song_mlist_page.dart';

class Router{
  //初始化路由
  static String initialRoute ='/launch';
  //命名路由(静态路由)
  static Map<String, Widget Function(BuildContext)> routes={
      '/launch':(BuildContext context) => LandingPage(),
      '/home':(BuildContext context) => HomePage(),
    };
 //自定义路由跳转

  static fadeNavigator(BuildContext context,String routeName,Map params,pop){
   Widget pageWidget;
   switch(routeName){
      case'/launch':
      pageWidget=LandingPage();
      break;
      case'/home':
      pageWidget=HomePage(params:params);
      break;
     case'/songmenu':
       pageWidget=SongMenu(params:params);
       break;
     case'/songmenulist':
       pageWidget=SongMenuList(params:params);
       break;

   }
    if(pageWidget!=null){
      if(params['from']=='/launch'){
        Navigator.pushAndRemoveUntil(context, FadeRoute(page: pageWidget),(route) => route == null).then((Object result) {
          pop(result);
        });
      }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) {
          return pageWidget;
          })).then((Object result) {
            pop(result);
          });
      }
    }else{
      Navigator.of(context).pushNamed(routeName).then((Object result) {
        pop(result);
      });
    }

//    Navigator.push(context, EnterExitRoute(exitPage: LandingPage(), enterPage:  HomePage()));
  }

  static goHome(BuildContext context,Map params,pop){

    Navigator.pushAndRemoveUntil(context, EnterExitRoute(exitPage:LandingPage(),enterPage:HomePage(params:params)),(route) => route == null).then((Object result) {
      pop(result);
    });

    }


}


