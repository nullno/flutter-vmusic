/*
   系统平台设置
*/
import 'package:flutter/services.dart';
import 'dart:io';

class SYS {
    static systemUI(statusBarColor,navColor,brightcolor){
      if (Platform.isAndroid) {
        // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:statusBarColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:statusBarColor,
            statusBarIconBrightness:brightcolor,
//            statusBarBrightness:brightcolor,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    }
    static hideBar(){
         SystemChrome.setEnabledSystemUIOverlays([]);
    }
    static hideTopBar(){
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
    static showBar(){
         SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }


}
