/*
   系统平台设置
*/
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SYS {
    static systemUI(statusBarColor,navColor){
      if (Platform.isAndroid) {
        // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:statusBarColor,systemNavigationBarColor: navColor);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    }
    static hideBar(){
         SystemChrome.setEnabledSystemUIOverlays([]);
    }
    static showBar(statusBarColor,iconColor){
         SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }


}
